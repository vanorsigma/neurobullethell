extends Node2D

@export_node_path("Node2D") var target_node: NodePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_node:
		rotation = (get_node(target_node).global_position - global_position).angle()
