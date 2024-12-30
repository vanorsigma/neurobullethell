extends Node2D

var pregame = preload("res://scenes/pregame.tscn")
var lore = preload("res://scenes/lore.tscn")
var level1 = preload("res://scenes/levels/level1.tscn")
var level2 = preload("res://scenes/levels/level2.tscn")
var level3 = preload("res://scenes/levels/level3.tscn")
var level4 = preload("res://scenes/levels/level4.tscn")
var final = preload("res://scenes/levels/final.tscn")

var levels = [pregame, lore, level1, level2, level3, level4, final]

var levels_index = 0
var instantiated_level = null

func prepare_level(level: PackedScene) -> void:
	if instantiated_level:
		instantiated_level.queue_free()

	get_tree().paused = false
	await get_tree().process_frame

	instantiated_level = levels[levels_index].instantiate()
	add_child(instantiated_level)
	Globals.level_begin.emit()

func _ready() -> void:
	Globals.restart_request.connect(self._on_level_restart)
	Globals.next_level_request.connect(self._next_level_request)
	Globals.game_over.connect(self._on_game_over)
	prepare_level(levels[levels_index])

func _on_game_over() -> void:
	get_tree().paused = true

func _on_level_restart() -> void:
	instantiated_level.queue_free()
	prepare_level(levels[levels_index])

func _next_level_request() -> void:
	levels_index += 1
	if levels_index >= levels.size():
		levels_index = 0
	prepare_level(levels[levels_index])

func _process(delta: float) -> void:
	pass
