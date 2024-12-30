extends Node2D

enum GameState { PLAY, PAUSE, GAME_OVER, LEVEL_COMPLETE }

var player: Player
var state = GameState.PLAY

signal bullet_hit(body: Node, damage: int)
signal self_destruct()
signal game_over()
signal level_begin()
signal level_complete()
signal pause(is_paused: bool)

signal restart_request()
signal next_level_request()

func _ready():
	game_over.connect(_on_game_over)
	level_complete.connect(_on_level_complete)
	pause.connect(_on_pause)
	level_begin.connect(_on_level_begin)

func _on_level_begin():
	state = GameState.PLAY

func _on_game_over():
	state = GameState.GAME_OVER

func _on_level_complete():
	state = GameState.LEVEL_COMPLETE

func _on_pause(is_paused: bool):
	if is_paused:
		state = GameState.PAUSE
	else:
		state = GameState.PLAY
