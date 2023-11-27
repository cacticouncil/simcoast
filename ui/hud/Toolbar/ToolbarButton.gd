extends VBoxContainer

var buttonGroup = preload("res://toolbar_button_group.tres")

func set_up_button(buttonName, iconPath):
	$Name.text = buttonName.capitalize()
	
	$CenterContainer/button.texture_normal = load(iconPath + "_normal.png")
	$CenterContainer/button.texture_pressed = load(iconPath + "_active.png")
	$CenterContainer/button.texture_hover = load(iconPath + "_hover.png")
	$CenterContainer/button.texture_focused = load(iconPath + "_active.png")
	$CenterContainer/button.group = buttonGroup
	
	
	#Should be last always
	$CenterContainer/button.name = buttonName + "_button"

func _ready():
	get_child(0).rect_position.x += 16
