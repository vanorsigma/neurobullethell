extends Control

var can_scroll = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var stream = $AudioStreamPlayer.stream as AudioStreamWAV
	($AudioStreamPlayer.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# slowly scroll $Control, but don't scroll past the end
	if not can_scroll:
		return
	$Control.position.y -= 50 * delta
	if $Control.position.y < -($Control.size.y - get_viewport().size.y):
		$Control.position.y = -($Control.size.y - get_viewport().size.y)

func _on_before_start_scroll_timer_timeout() -> void:
	can_scroll = true
