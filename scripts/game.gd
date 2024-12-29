extends Node2D

var level1 = preload("res://scenes/levels/level1.tscn")

var levels = [level1]

var levels_index = 0
var instantiated_level = null

func prepare_level(level: PackedScene) -> void:
	if instantiated_level:
		instantiated_level.queue_free()

	get_tree().paused = false
	instantiated_level = levels[levels_index].instantiate()
	add_child(instantiated_level)

func _ready() -> void:
	Globals.restart_request.connect(self._on_level_restart)
	Globals.game_over.connect(self._on_game_over)
	prepare_level(levels[levels_index])

func _on_game_over() -> void:
	get_tree().paused = true

func _on_level_restart() -> void:
	instantiated_level.queue_free()
	prepare_level(levels[levels_index])

func _process(delta: float) -> void:
	pass
