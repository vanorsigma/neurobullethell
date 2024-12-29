extends CharacterBody2D

enum Direction { UP, LEFT, RIGHT, IDLE }

@export var base_speed: float = 100
@export var boots_modifier: float = 5
@export var health: float = 500
@export var shield: float = 500

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
	if body == self or body == $Shield:
		do_damage(damage)

func do_damage(damage: int, bypass_crown: bool = false) -> void:
	var potential_hp_damage = max(0, damage - shield)

	if has_shield:
		if has_crown and not bypass_crown:
			return
		shield = max(0, shield - damage)

	health -= potential_hp_damage
	if health <= 0:
		_die()

func _die() -> void:
	$Explosion.visible = true
	$Explosion/Audio.play()
	$Explosion.play("default")
	await $Explosion.animation_finished
	Globals.game_over.emit()

func _play_animation(direction: Direction) -> void:
	match direction:
		Direction.UP:
			$PlayerSprite.play("idle_up" if has_boots else "walk_up")
			flightBoots.play("up")
			armor.play("idle_up" if has_boots else "walk_up")
			crown.play("up")
		Direction.LEFT:
			$PlayerSprite.play("idle_left" if has_boots else "walk_left")
			$PlayerSprite.flip_h = has_boots
			flightBoots.play("left")
			flightBoots.flip_h = has_boots
			armor.play("idle_right")
			armor.flip_h = has_boots
			crown.play("left")
		Direction.RIGHT:
			$PlayerSprite.play("idle_left" if has_boots else "walk_left")
			$PlayerSprite.flip_h = not has_boots
			flightBoots.play("left")
			flightBoots.flip_h = not has_boots
			armor.play("idle_right" if has_boots else "walk_left")
			armor.flip_h = not has_boots
			crown.play("right")
		Direction.IDLE when not has_boots:
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
					armor.play("idle_left")
					armor.flip_h = false
					crown.play("left")
				Direction.RIGHT:
					$PlayerSprite.play("idle_left")
					$PlayerSprite.flip_h = true
					flightBoots.play("left")
					flightBoots.flip_h = true
					armor.play("idle_left")
					armor.flip_h = true
					crown.play("right")
		Direction.IDLE when has_boots:
			$PlayerSprite.play("idle_up")
			flightBoots.play("up")
			armor.play("idle_up")
			crown.play("up")

	previous_direction = direction
	$Shield/ShieldSprite.play("crowned" if has_crown else "default")

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

	# put global position of self in debuglabel
	$DebugLabel.text = str(global_position)

func _physics_process(delta: float) -> void:
	move_and_slide()
