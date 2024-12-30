extends Node2D

const crown_dialogue = preload("res://dialogue/crown.dialogue")
const cfrb = preload("res://dialogue/cfrb.dialogue")
const shoe = preload("res://dialogue/shoe.dialogue")
const shield = preload("res://dialogue/shield.dialogue")

enum GameState { PLAY, PAUSE, GAME_OVER, LEVEL_COMPLETE, CUSTOMIZATION }

var player: Player
# var selected_items: int = 0b111111
var selected_items: int = 0b000111
var state = GameState.PLAY
# var story = 0
var story = 2
var is_story_death = false

var possible_death_dialogues = [crown_dialogue, cfrb, shoe, shield]

signal bullet_hit(body: Node, damage: int, armor_bullet: bool)
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
	is_story_death = false

func _on_game_over():
	state = GameState.GAME_OVER

	# the death dialogues themselves have logic to quit early
	for dialogue in possible_death_dialogues:
		var dialog_node = DialogueManager.show_dialogue_balloon(dialogue)
		dialog_node.process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _on_level_complete():
	state = GameState.LEVEL_COMPLETE

func _on_pause(is_paused: bool):
	if is_paused:
		state = GameState.PAUSE
	else:
		state = GameState.PLAY
