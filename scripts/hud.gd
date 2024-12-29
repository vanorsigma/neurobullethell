extends Control

@export var hp: int = 100
@export var max_hp: int = 100
@export var shield: int = 0
@export var max_shield: int = 100

@export var has_crown: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HPBar.value = hp
	$HPBar.max_value = max_hp
	$ShieldBar.value = shield
	$ShieldBar.max_value = max_shield
	$ShieldBar/Crowned.visible = has_crown
