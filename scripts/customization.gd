extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VisionMat.selected = Globals.selected_items & 0b000001
	$ForwardMat.selected = Globals.selected_items & 0b000010
	$ShieldMat.selected = Globals.selected_items & 0b000100
	$WingedBootsMat.selected = Globals.selected_items & 0b001000
	$CFRBMat.selected = Globals.selected_items & 0b010000
	$CrownMat.selected = Globals.selected_items & 0b100000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vision_mat_on_selected(is_selected: bool) -> void:
	if is_selected:
		Globals.selected_items = Globals.selected_items | 0b000001
	else:
		Globals.selected_items = Globals.selected_items & 0b111110

func _on_forward_mat_on_selected(is_selected: bool) -> void:
	if is_selected:
		Globals.selected_items = Globals.selected_items | 0b000010
	else:
		Globals.selected_items = Globals.selected_items & 0b111101


func _on_shield_mat_on_selected(is_selected: bool) -> void:
	if is_selected:
		Globals.selected_items = Globals.selected_items | 0b000100
	else:
		Globals.selected_items = Globals.selected_items & 0b111011


func _on_winged_boots_mat_on_selected(is_selected: bool) -> void:
	if is_selected:
		Globals.selected_items = Globals.selected_items | 0b001000
	else:
		Globals.selected_items = Globals.selected_items & 0b110111


func _on_cfrb_mat_on_selected(is_selected: bool) -> void:
	if is_selected:
		Globals.selected_items = Globals.selected_items | 0b010000
	else:
		Globals.selected_items = Globals.selected_items & 0b101111


func _on_crown_mat_on_selected(is_selected: bool) -> void:
	if is_selected:
		Globals.selected_items = Globals.selected_items | 0b100000
	else:
		Globals.selected_items = Globals.selected_items & 0b011111


func _on_close_pressed() -> void:
	visible = false
