extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(node: Node2D) -> void:
	if node == $BaseLevel/Player and $BaseLevel/Player.has_crown:
		$BaseLevel/Player.do_damage(999999999, true)
