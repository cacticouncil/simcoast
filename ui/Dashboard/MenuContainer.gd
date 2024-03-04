extends VBoxContainer

var minus_icon = preload("res://assets/buttons/minus_button.png")
var plus_icon = preload("res://assets/buttons/plus_button.png")
var minus_icon_hover = preload("res://assets/buttons/minus_button_hover.png")
var plus_icon_hover = preload("res://assets/buttons/plus_button_hover.png")

var badges_open = false
var characters_open = false
var sensors_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../").get_v_scrollbar().rect_scale.x = 0
	get_node("ColorRect2/ScrollContainer").get_v_scrollbar().rect_scale.x = 0
	add_constant_override("separation", 6)
	$ColorRect/UnlockedBadges.visible = false
	$ColorRect2/ScrollContainer/DisplayCharacterCards.visible = false


# Badge button functions (press and hover)
func _on_BadgesButton_pressed():
	#If opened, "closes" badges by decreasing colorRect's size and hiding badges.
	#Also changes button icon.
	#This is the general functionality for all three menu popups.
	if badges_open:
		$ColorRect.rect_min_size.y = 40
		$ColorRect/BadgesButton.icon = plus_icon
		$ColorRect/UnlockedBadges.visible = false
	else:
		$ColorRect.rect_min_size.y = 300
		$ColorRect/BadgesButton.icon = minus_icon
		$ColorRect/UnlockedBadges.visible = true
	badges_open = !badges_open
#Hover state previews the popups.
func _on_BadgesButton_mouse_entered():
	if !badges_open:
		$ColorRect.rect_min_size.y = 300
		$ColorRect/UnlockedBadges.visible = true
		$ColorRect/BadgesButton.icon = plus_icon_hover
	else:
		$ColorRect/BadgesButton.icon = minus_icon_hover
func _on_BadgesButton_mouse_exited():
	if !badges_open:
		$ColorRect.rect_min_size.y = 40
		$ColorRect/BadgesButton.icon = plus_icon
		$ColorRect/UnlockedBadges.visible = false
	else:
		$ColorRect/BadgesButton.icon = minus_icon


#Characters button functions (press and hover)
func _on_CharactersButton_pressed():
	if characters_open:
		$ColorRect2.rect_min_size.y = 40
		$ColorRect2/CharactersButton.icon = plus_icon
		$ColorRect2/ScrollContainer/DisplayCharacterCards.visible = false
	else:
		$ColorRect2.rect_min_size.y = 350
		$ColorRect2/CharactersButton.icon = minus_icon
		$ColorRect2/ScrollContainer/DisplayCharacterCards.visible = true
	characters_open = !characters_open
func _on_CharactersButton_mouse_entered():
	if !characters_open:
		$ColorRect2.rect_min_size.y = 350
		$ColorRect2/ScrollContainer/DisplayCharacterCards.visible = true
		$ColorRect2/CharactersButton.icon = plus_icon_hover
	else:
		$ColorRect2/CharactersButton.icon = minus_icon_hover
func _on_CharactersButton_mouse_exited():
	if !characters_open:
		$ColorRect2.rect_min_size.y = 40
		$ColorRect2/ScrollContainer/DisplayCharacterCards.visible = false
		$ColorRect2/CharactersButton.icon = plus_icon
	else:
		$ColorRect2/CharactersButton.icon = minus_icon
		

#Sensor button functions (press and hover)
func _on_SensorButton_pressed():
	if sensors_open:
		$ColorRect3.rect_min_size.y = 40
		$ColorRect3/SensorButton.icon = plus_icon
	else:
		$ColorRect3.rect_min_size.y = 300
		$ColorRect3/SensorButton.icon = minus_icon
	sensors_open = !sensors_open
func _on_SensorButton_mouse_entered():
	if !sensors_open:
		$ColorRect3.rect_min_size.y = 300
		$ColorRect3/SensorButton.icon = plus_icon_hover
	else:
		$ColorRect3/SensorButton.icon = minus_icon_hover
func _on_SensorButton_mouse_exited():
	if !sensors_open:
		$ColorRect3.rect_min_size.y = 40
		$ColorRect3/SensorButton.icon = plus_icon
	else:
		$ColorRect3/SensorButton.icon = minus_icon

#expand all function, expands all three popups.	
func _on_ExpandAllButton_pressed():
	$ColorRect.rect_min_size.y = 300
	$ColorRect2.rect_min_size.y = 350
	$ColorRect3.rect_min_size.y = 300
	$ColorRect/UnlockedBadges.visible = true
	$ColorRect2/ScrollContainer/DisplayCharacterCards.visible = true
	badges_open = true
	characters_open = true
	sensors_open = true
	$ColorRect/BadgesButton.icon = minus_icon
	$ColorRect2/CharactersButton.icon = minus_icon
	$ColorRect3/SensorButton.icon = minus_icon
#collapse all function, collapses all three popups.
func _on_CollapseAllButton_pressed():
	$ColorRect.rect_min_size.y = 40
	$ColorRect2.rect_min_size.y = 40
	$ColorRect3.rect_min_size.y = 40
	$ColorRect/UnlockedBadges.visible = false
	$ColorRect2/ScrollContainer/DisplayCharacterCards.visible = false
	badges_open = false
	characters_open = false
	sensors_open = false
	$ColorRect/BadgesButton.icon = plus_icon
	$ColorRect2/CharactersButton.icon = plus_icon
	$ColorRect3/SensorButton.icon = plus_icon



