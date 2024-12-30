extends Node2D

var post_level_dialogue = preload("res://dialogue/post_level_2.dialogue")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BaseLevel.cameraSpeed = Globals.player.boots_modifier * 100 if Globals.player.has_boots else 100
	Globals.level_complete.connect(self._level_complete)

	($AudioStreamPlayer.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_anticrown_entered(body:Node2D) -> void:
	if body == Globals.player and Globals.player.has_crown:
		Globals.player.do_damage(999999999, true)


func _on_shield_detect_body_entered(body:Node2D) -> void:
	if body == Globals.player:
		$ShieldRepower.queue_free()
		Globals.player.shield = 300

func _level_complete() -> void:
	var stream = $AudioStreamPlayer.stream as AudioStreamWAV
	($AudioStreamPlayer.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED

	var dialog_node = DialogueManager.show_dialogue_balloon(post_level_dialogue)
	dialog_node.process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	await DialogueManager.dialogue_ended
