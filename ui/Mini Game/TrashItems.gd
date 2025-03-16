extends Area2D

# Define a custom signal
signal item_dropped

var dragging = false
var offset = Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				if is_mouse_inside_circle():
					dragging = true
					offset = global_position - get_global_mouse_position()
			elif !event.is_pressed() and dragging:
				dragging = false
				emit_signal("item_dropped", $Sprite.texture.resource_path, global_position)
				
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() + offset

func is_mouse_inside_circle() -> bool:
	var mouse_pos = get_global_mouse_position()
	return (global_position - mouse_pos).length() <= $CollisionShape2D.shape.radius
