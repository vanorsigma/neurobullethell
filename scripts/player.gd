extends CharacterBody2D

enum Direction { UP, LEFT, RIGHT, IDLE }

@export var base_speed: float = 100
@export var boots_modifier: float = 5
@export var health: float = 999999
@export var shield: float = 999999

@export var has_shield: bool = true
@export var has_boots = true
@export var has_crown = true
@export var has_armor = true

@onready var flightBoots = $PlayerSprite/FlightBoots
@onready var crown = $PlayerSprite/Crown
@onready var armor = $PlayerSprite/Armor

var previous_direction: Direction = Direction.IDLE

func _ready() -> void:
	Globals.bullet_hit.connect(_on_bullet_hit_dispatcher)

	flightBoots.visible = has_boots
	crown.visible = has_crown
	armor.visible = has_armor


func _on_bullet_hit_dispatcher(body: Node, damage: int) -> void:
	if body == self:
		_on_player_hit(damage)

	if body == $Shield:
		_on_shield_hit(damage)

func _on_player_hit(damage: int) -> void:
	health -= damage

func _on_shield_hit(damage: int) -> void:
	if has_crown:
		return
	shield = max(0, shield - damage)

func _play_animation(direction: Direction) -> void:
	match direction:
		Direction.UP:
			$PlayerSprite.play("idle_up" if has_boots else "walk_up")
			flightBoots.play("up")
			armor.play("idle_up" if has_boots else "walk_up")
			crown.play("up")
		Direction.LEFT:
			$PlayerSprite.play("idle_left" if has_boots else "walk_left")
			$PlayerSprite.flip_h = false
			flightBoots.play("left")
			flightBoots.flip_h = false
			armor.play("idle_up" if has_boots else "walk_up")
			armor.flip_h = false
			crown.play("left")
		Direction.RIGHT:
			$PlayerSprite.play("idle_left" if has_boots else "walk_left")
			$PlayerSprite.flip_h = true
			flightBoots.play("left")
			flightBoots.flip_h = true
			armor.play("idle_up" if has_boots else "walk_up")
			armor.flip_h = true
			crown.play("right")
		Direction.IDLE:
			match previous_direction:
				Direction.UP:
					$PlayerSprite.play("idle_up")
					flightBoots.play("up")
					armor.play("idle_up")
					crown.play("up")
				Direction.LEFT:
					$PlayerSprite.play("idle_left")
					$PlayerSprite.flip_h = false
					flightBoots.play("left")
					flightBoots.flip_h = false
					armor.play("idle_up")
					armor.flip_h = false
					crown.play("left")
				Direction.RIGHT:
					$PlayerSprite.play("idle_left")
					$PlayerSprite.flip_h = true
					flightBoots.play("left")
					flightBoots.flip_h = true
					armor.play("idle_up")
					armor.flip_h = true
					crown.play("right")

	previous_direction = direction

func _process(delta: float) -> void:
	$Shield.visible = shield > 0

	velocity = Vector2(0, 0)
	var animation_direction = Direction.IDLE

	if Input.is_action_pressed("up"):
		velocity.y = -base_speed * (boots_modifier if has_boots else 1.0)
		animation_direction = Direction.UP
	if Input.is_action_pressed("down"):
		velocity.y = base_speed * (boots_modifier if has_boots else 1.0)
		animation_direction = Direction.UP
	if Input.is_action_pressed("left"):
		velocity.x = -base_speed * (boots_modifier if has_boots else 1.0)
		animation_direction = Direction.LEFT
	if Input.is_action_pressed("right"):
		velocity.x = base_speed * (boots_modifier if has_boots else 1.0)
		animation_direction = Direction.RIGHT

	_play_animation(animation_direction)

	$DebugLabel.text = "Health: " + str(health) + "\nShield: " + str(shield)

func _physics_process(delta: float) -> void:
	move_and_slide()
