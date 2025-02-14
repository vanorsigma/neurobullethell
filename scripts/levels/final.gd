extends Node2D

var dialogue = preload("res://dialogue/final.dialogue")
var endRoll = preload("res://scenes/end_roll.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialog_node = DialogueManager.show_dialogue_balloon(dialogue)
	dialog_node.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	await DialogueManager.dialogue_ended

	var parent = get_parent()
	queue_free()
	parent.add_child(endRoll.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
