extends Control

@export var title: String = "Title"
@export var description: String = "Description"
@export var icon: Texture

@onready var Title = get_node("Panel/VBoxContainer/Title")
@onready var Description = get_node("Panel/VBoxContainer/Description")


func _ready() -> void:
	$RemnantSprite.texture = icon
	Title.text = title
	Description.text = description

func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	$Panel.show()


func _on_area_2d_mouse_exited() -> void:
	$Panel.hide()
