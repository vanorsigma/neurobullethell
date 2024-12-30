extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
