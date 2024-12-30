extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Globals.state == Globals.GameState.PLAY or Globals.state == Globals.GameState.PAUSE:
			visible = not visible
			get_tree().paused = visible

			Globals.pause.emit(Globals.state == Globals.GameState.PLAY)


func _on_selfdestruct_pressed() -> void:
	get_tree().paused = false
	visible = false
	Globals.self_destruct.emit()


func _on_continue_pressed() -> void:
	if Globals.state == Globals.GameState.PAUSE:
		get_tree().paused = false
		visible = false
