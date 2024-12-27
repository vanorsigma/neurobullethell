extends CharacterBody2D

@export var base_speed: float = 100
@export var health: float = 100
@export var shield: float = 100

func _ready() -> void:
	Globals.bullet_hit.connect(_on_bullet_hit_dispatcher)

func _on_bullet_hit_dispatcher(body: Node, damage: int) -> void:
	print(body)
	if body == self:
		_on_player_hit(damage)

	if body == $Shield:
		_on_shield_hit(damage)

func _on_player_hit(damage: int) -> void:
	health -= damage

func _on_shield_hit(damage: int) -> void:
	shield = max(0, shield - damage)

func _process(delta: float) -> void:
	$Shield.visible = shield > 0

	velocity = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		velocity.y = -base_speed
	if Input.is_action_pressed("down"):
		velocity.y = base_speed
	if Input.is_action_pressed("left"):
		velocity.x = -base_speed
	if Input.is_action_pressed("right"):
		velocity.x = base_speed

	$DebugLabel.text = "Health: " + str(health) + "\nShield: " + str(shield)

func _physics_process(delta: float) -> void:
	move_and_slide()
