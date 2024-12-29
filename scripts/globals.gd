extends Node2D

var player: Player

signal bullet_hit(body: Node, damage: int)
signal game_over()
signal level_complete()

signal restart_request()
signal next_level_request()
