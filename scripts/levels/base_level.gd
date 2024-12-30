extends Node2D

@export var cameraSpeed: float = 100
@export var onCameraMakeVisibleAndFollow: Array[Node] = []
@export var endingNotifier: VisibleOnScreenNotifier2D

@onready var hud = $WorldCamera/Hud
@onready var dash = $WorldCamera/Hud/Dash
@onready var pauseScreen = $WorldCamera/PauseScreen
@onready var blinkCooldownTimer = $Player/BlinkCooldownTimer

var trackingArray = []
var ended = false

func _set_player_to_customization() -> void:
	$Player.has_shield = Globals.selected_items & 0b000100
	$Player.has_boots = Globals.selected_items & 0b001000
	$Player.has_armor = Globals.selected_items & 0b010000
	$Player.has_crown = Globals.selected_items & 0b100000

func _ready() -> void:
	if not endingNotifier:
		printerr("EndingNotifier not set in BaseLevel, but we'll continue anyway")
	else:
		endingNotifier.screen_entered.connect(self._on_ending_visible)

	_set_player_to_customization()

	$Player.health = 500 if $Player.has_armor else 100
	hud.max_hp = $Player.health
	dash.visible = not $Player.has_boots
	dash.max_value = blinkCooldownTimer.wait_time
	hud.max_shield = $Player.shield

	for node in onCameraMakeVisibleAndFollow:
		assert(node.has_node("VisibleOnScreenNotifier2D"), "Node must have a VisibleOnScreenNotifier2D child")
		assert(node.has_node("ExpiryTimer"), "Node must have a Timer child called ExpiryTimer")

		var notifier = node.get_node("VisibleOnScreenNotifier2D")
		var expiryTimer = node.get_node("ExpiryTimer")

		notifier.screen_entered.connect(self._on_visible.bind(node))
		expiryTimer.timeout.connect(self._on_expiry.bind(node))

	Globals.level_complete.connect(self._on_level_complete)
	Globals.game_over.connect(self._on_game_over)

func _on_level_complete() -> void:
	$WorldCamera/LevelClear.visible = true

func _on_game_over() -> void:
	$WorldCamera/GameOver.visible = true

func _on_visible(node: Node) -> void:
	for child in node.get_children():
		if child is Node2D:
			child.visible = true
	trackingArray.append(node)
	node.get_node("ExpiryTimer").start()

func _on_ending_visible() -> void:
	ended = true
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
	cameraSpeed *= 5.0
	Globals.level_complete.emit()

func _on_expiry(node: Node) -> void:
	for child in node.get_children():
		if child is Node2D:
			child.visible = false
	trackingArray.erase(node)
	node.queue_free()

func _process(delta: float) -> void:
	if not ended:
		$WorldCamera.position.y -= cameraSpeed * delta
	$Player.position.y -= cameraSpeed * delta

	hud.hp = $Player.health
	hud.shield = $Player.shield
	hud.has_crown = $Player.has_crown
	dash.value = blinkCooldownTimer.wait_time - blinkCooldownTimer.time_left

	for node in trackingArray:
		node.position.y -= cameraSpeed * delta
