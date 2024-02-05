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

func set_bg(size, clr):
	#Easier to update these in code, because otherwise Vbox overwrites the values
	$Title/BG.rect_size = size
	$Title/BG.color = clr

