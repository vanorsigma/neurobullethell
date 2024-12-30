extends CharacterBody2D
class_name Player

enum Direction { UP, LEFT, RIGHT, IDLE }

@export var base_speed: float = 100
@export var boots_modifier: int = 3
@export var health: float = 500
@export var shield: float = 300
@export var blink_speed_modifier: float = 7

@export var has_shield: bool = true
@export var has_boots = true
@export var has_crown = true
@export var has_armor = true

@onready var flightBoots = $PlayerSprite/FlightBoots
@onready var crown = $PlayerSprite/Crown
@onready var armor = $PlayerSprite/Armor

var invincible = false
var previous_direction: Direction = Direction.IDLE

func _ready() -> void:
	Globals.player = self
	Globals.bullet_hit.connect(_on_bullet_hit_dispatcher)
	Globals.self_destruct.connect(do_damage.bind(999999999, true))

func _on_bullet_hit_dispatcher(body: Node, damage: int, armor_bullet: bool) -> void:
	if body == self or body == $Shield and not invincible:
		do_damage(damage)
		if armor_bullet and has_armor:
			Globals.is_story_death = true
			do_damage(999999999, true)
			invincible = true

func do_damage(damage: int, bypass_crown: bool = false) -> void:
	if invincible:
		return

	var potential_hp_damage = max(0, damage - shield)

	if has_shield and shield > 0:
		if has_crown and not bypass_crown:
			return
		shield = shield - damage
		if shield <= 0:
			$Shield/ShieldDown.play()

	health -= potential_hp_damage
	if potential_hp_damage:
		_damage_blink()
	if health <= 0:
		_die()

func _damage_blink() -> void:
	invincible = true
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(0.2)

	$PlayerSprite.modulate = Color(1, 0, 0, 1)
	timer.start()
	await timer.timeout

	$PlayerSprite.modulate = Color(1, 1, 1, 1)
	timer.start()
	await timer.timeout

	$PlayerSprite.modulate = Color(1, 0, 0, 1)
	timer.start()
	await timer.timeout

	$PlayerSprite.modulate = Color(1, 1, 1, 1)
	invincible = false
	timer.queue_free()

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
	flightBoots.visible = has_boots
	crown.visible = has_crown
	armor.visible = has_armor
	$Shield.visible = shield > 0

	if not $BlinkTimer.is_stopped():
		return

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

	if Input.is_action_pressed("blink") and $BlinkCooldownTimer.is_stopped() and not has_boots:
		invincible = true
		velocity.x *= blink_speed_modifier
		velocity.y *= blink_speed_modifier
		$BlinkTimer.start()
		$BlinkCooldownTimer.start()

	_play_animation(animation_direction)

	# put global position of self in debuglabel
	$DebugLabel.text = str(global_position)

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_blink_timer_timeout() -> void:
	invincible = false
