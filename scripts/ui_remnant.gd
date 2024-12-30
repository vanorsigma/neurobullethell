extends Control

signal on_selected(is_selected: bool)

@export var title: String = "Title"
@export_multiline var description: String = "Description"
@export var icon: Texture
@export var selected: bool = true

@onready var Title = get_node("Panel/VBoxContainer/Title")
@onready var Description = get_node("Panel/VBoxContainer/Description")


func _ready() -> void:
	$RemnantSprite.texture = icon
	Title.text = title
	Description.text = description

func _process(delta: float) -> void:
	$Checkmark.visible = selected
	$SelectedSprite.visible = selected
	if $Panel.visible:
		$Panel.global_position = $RemnantSprite.get_global_mouse_position()
		if $Panel.global_position.x + $Panel.get_rect().size.x > get_viewport().size.x:
			$Panel.global_position.x = get_viewport().size.x - $Panel.get_rect().size.x

func _on_area_2d_mouse_entered() -> void:
	$Panel.show()

func _on_area_2d_mouse_exited() -> void:
	$Panel.hide()

func _on_area_2d_input_event(viewport:Node, event:InputEvent, shape_idx:int) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).pressed:
			selected = !selected
			on_selected.emit(selected)
