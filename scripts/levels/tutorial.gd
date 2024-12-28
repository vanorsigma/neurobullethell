extends Node2D

@export var cameraSpeed: float = 100

func _ready() -> void:
	# get_node("Player/Camera2D").make_current()
	Spawning.spawn($SpawnPoint, "Intro1")

func _process(delta: float) -> void:
	$WorldCamera.position.y -= cameraSpeed * delta
	$Player.position.y -= cameraSpeed * delta
