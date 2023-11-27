extends VBoxContainer

var toolbarButtonScene = preload("res://ui/hud/Toolbar/ToolbarButton.tscn")

# buttons is a list of lists of size 2. In the list is [buttonName, iconPath]
func add_button(sectionName, buttons):
	$Title.text = sectionName
	
	var container
	
	for i in range(buttons.size()):
		# We have 3 achievements side by side, then print on the next row
		if i % 2 == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 0)
			add_child(container)
			# This random control node was the easiest way to get the first spacing
			container.add_child(Control.new())
		
		var currButton = toolbarButtonScene.instance()
		currButton.set_up_button(buttons[i][0], buttons[i][1])
		
		container.add_child(currButton)
	#Adds a bit of a space
	add_child(Control.new())

func set_bg(size, clr):
	$Title/BG.rect_size = size
	$Title/BG.color = clr

