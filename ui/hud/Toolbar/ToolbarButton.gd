extends VBoxContainer

var buttonGroup = preload("res://toolbar_button_group.tres")

func set_up_button(buttonName, iconPath):
	$Name.text = buttonName.capitalize()
	
	$button.texture_normal = load(iconPath + "_normal.png")
	$button.texture_pressed = load(iconPath + "_active.png")
	$button.texture_hover = load(iconPath + "_hover.png")
	$button.texture_focused = load(iconPath + "_active.png")
	$button.group = buttonGroup
	
	#Should be last always
	$button.name = buttonName + "_button"
