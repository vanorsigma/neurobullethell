extends Node2D

@export var cameraSpeed: float = 100

@onready var hud = $WorldCamera/Hud

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$WorldCamera.position.y -= cameraSpeed * delta
	$Player.position.y -= cameraSpeed * delta

	hud.hp = $Player.health
	hud.shield = $Player.shield
	hud.has_crown = $Player.has_crown
