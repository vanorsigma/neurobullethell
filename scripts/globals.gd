extends Node2D

var player: Player

signal bullet_hit(body: Node, damage: int)
signal game_over()
signal level_complete()
