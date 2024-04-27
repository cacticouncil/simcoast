extends VBoxContainer

var toolbarButtonScene = preload("res://ui/hud/Toolbar/ToolbarButton.tscn")

# buttons is a list of lists with two elements. The elements are [buttonName, iconPath]
func add_button(sectionName, buttons):
	$Title.text = sectionName
	
	var container
	
	for i in range(buttons.size()):
		# We add 2 buttons, then create another row
		if i % 2 == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 0)
			add_child(container)
			# This random control node was the easiest way to get the first spacing
			container.add_child(Control.new())
		
		var currButton = toolbarButtonScene.instance()
		currButton.set_up_button(buttons[i][0], buttons[i][1], buttons[i][2])
		
		container.add_child(currButton)
	#Adds a bit of a space
	add_child(Control.new())

func add_one_button(button):
	get_children()[-1].free()
	var lastChild = get_children()[-1]
	var resize = false
	if (len(lastChild.get_children()) == 3) || !(lastChild is HBoxContainer):
		lastChild = HBoxContainer.new()
		lastChild.set("custom_constants/separation", 0)
		add_child(lastChild)
		# This random control node was the easiest way to get the first spacing
		lastChild.add_child(Control.new())
		resize = true
	
	var currButton = toolbarButtonScene.instance()
	currButton.set_up_button(button[0], button[1], button[2])
	
	lastChild.add_child(currButton)
	if resize:
		rect_size = Vector2(rect_size.x, rect_size.y + currButton.rect_size.y + 4)
	add_child(Control.new())

func set_bg(size, clr):
	#Easier to update these in code, because otherwise Vbox overwrites the values
	$Title/BG.rect_size = size
	$Title/BG.color = clr

func resize_bg(size):
	$Title/BG.rect_size = size

# only used for sensors so sensor-specific to fix a bug
func remove_button(button):
	var children = get_children()
	var adjust = -1
	#if all sensors are bought 
	# tide sensor (1st sensor)
	#print(children[1].get_child(1).get_child(1).text)
	# rain sensor (2nd sensor)
	#print(children[1].get_child(2).get_child(1).text)
	# wind sensor (3rd sensor)
	#print(children[2].get_child(1).get_child(1).text)
	
	# at most three sensors at a time
	# first sensor
	if children[1].get_child(1).get_child(1).text == button:
	#	print(children[1].get_child(1).get_child(1).text)
		#remove first sensor
		children[1].get_child(1).free()
		# check to see if there are more sensors
		# if there is a second sensor
		if (children[1].get_child(1) != null):
			#print("hey rain")
			# if there is a third sensor, it needs to be moved to child[1]
			if(children[2].get_child(1) != null):
				#print("hey wind")
				var childToMove = children[2].get_child(1)
				get_child(2).remove_child(childToMove)
				get_child(1).add_child(childToMove)
				if len(children[2].get_children()) == 1:
					children[2].queue_free()
				#print(children[1].get_child(1).get_child(1).text)
				#print(children[1].get_child(2).get_child(1).text)
		#no more sensors
		else:
			return true
	# second sensor
	elif children[1].get_child(2).get_child(1).text == button:
		#remove second sensor
		children[1].get_child(2).free()
		# if there is a third sensor, move it
		if(children[2].get_child(1) != null):
			#print("hey wind")
			var childToMove = children[2].get_child(1)
			get_child(2).remove_child(childToMove)
			get_child(1).add_child(childToMove)
			if len(children[2].get_children()) == 1:
				children[2].queue_free()
	#third sensor
	elif children[2].get_child(1).get_child(1).text == button:
		#remove third sensor
		children[2].get_child(1).free()
	
	return false
	
