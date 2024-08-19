extends Control



func _on_color_picker_color_changed(color: Color) -> void:
	$ColorRect.color = color

var full : bool = false
func _on_button_pressed() -> void:
	if full:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	full = !full
