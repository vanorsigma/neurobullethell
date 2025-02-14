extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Restart.mouse_filter = Control.MOUSE_FILTER_IGNORE if $Customization.visible else Control.MOUSE_FILTER_STOP
	$Inventory.mouse_filter = Control.MOUSE_FILTER_IGNORE if $Customization.visible else Control.MOUSE_FILTER_STOP

func _on_restart_pressed() -> void:
	Globals.restart_request.emit()

func _on_inventory_pressed() -> void:
	$Customization.visible = true
