extends Node2D

@export var cameraSpeed: float = 100

func _ready() -> void:
	Spawning.spawn($SpawnPoint, "Intro1")

func _process(delta: float) -> void:
	pass
