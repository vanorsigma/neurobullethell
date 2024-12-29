extends Node2D

func _ready() -> void:
	var scroll_speed = 5.0 if Globals.player.has_boots else 1.0
	$ParallaxBackground.scroll_base_scale = Vector2(scroll_speed, scroll_speed)

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(node: Node2D) -> void:
	if node == Globals.player and Globals.player.has_crown:
		Globals.player.do_damage(999999999, true)
