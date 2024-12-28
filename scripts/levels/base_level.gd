extends Node2D

@export var cameraSpeed: float = 100

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$WorldCamera.position.y -= cameraSpeed * delta
	$Player.position.y -= cameraSpeed * delta
