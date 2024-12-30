extends Node2D

@export var rotation_speed: float = 0.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	rotation += rotation_speed * delta
