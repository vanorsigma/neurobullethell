extends Node2D

func _ready() -> void:
	get_node("Player/Camera2D").make_current()
	Spawning.spawn($SpawnPoint, "Intro1")

func _process(delta: float) -> void:
	pass
