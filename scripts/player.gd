extends CharacterBody2D

@export var base_speed: float = 100

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("up"):
		velocity.y = -base_speed
	if Input.is_action_pressed("down"):
		velocity.y = base_speed
	if Input.is_action_pressed("left"):
		velocity.x = -base_speed
	if Input.is_action_pressed("right"):
		velocity.x = base_speed

func _physics_process(delta: float) -> void:
	move_and_slide()
