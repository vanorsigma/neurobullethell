extends Control

var dialogue = preload("res://dialogue/start.dialogue")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dialog_node = DialogueManager.show_dialogue_balloon(dialogue)
	dialog_node.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	await DialogueManager.dialogue_ended

	Globals.next_level_request.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
