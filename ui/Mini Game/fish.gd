extends Area2D

# State to track dragging
var is_dragging = false

# Offset between the mouse and the object's position when dragging
var drag_offset = Vector2.ZERO

func _input(event):
	# Check for mouse button events
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				print("Mouse")
				var shape = get_node("fishcollision").shape as CircleShape2D
				if shape:
					print('1')
					var distance = global_position.distance_to(get_global_mouse_position())
					if distance <= shape.radius:
						print('2')
						# Start dragging if left mouse button is pressed over the object
						is_dragging = true
						drag_offset = global_position - get_global_mouse_position()
			else:
				# Stop dragging when the button is released
				is_dragging = false

	# Check for mouse motion during dragging
	elif event is InputEventMouseMotion and is_dragging:
		# Update position to follow the mouse, maintaining the drag offset
		global_position = get_global_mouse_position() + drag_offset
