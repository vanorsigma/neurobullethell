extends Node2D

func _ready() -> void:
	# var scroll_speed = 5.0 if Globals.player.has_boots else 1.0
	# $ParallaxBackground.scroll_base_scale = Vector2(scroll_speed, scroll_speed)
	$BaseLevel.cameraSpeed = Globals.player.boots_modifier * 100 if Globals.player.has_boots else 100
	Globals.level_complete.connect(self._level_complete)

	($AudioStreamPlayer.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(node: Node2D) -> void:
	if node == Globals.player and Globals.player.has_crown:
		Globals.player.do_damage(999999999, true)

func _level_complete() -> void:
	var stream = $AudioStreamPlayer.stream as AudioStreamWAV
	($AudioStreamPlayer.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED
