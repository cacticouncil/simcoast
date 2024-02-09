extends VBoxContainer

var minus_icon = preload("res://assets/buttons/minus_button.png")
var plus_icon = preload("res://assets/buttons/plus_button.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../").get_v_scrollbar().rect_scale.x = 0
	add_constant_override("separation", 6)
	$ColorRect/UnlockedBadges.visible = false
	$ColorRect2/DisplayCharacterCards.visible = false
	
func _on_BadgesButton_pressed():
	if $ColorRect.rect_min_size.y == 300:
		$ColorRect.rect_min_size.y = 40
		$ColorRect/BadgesButton.icon = plus_icon
	else:
		$ColorRect.rect_min_size.y = 300
		$ColorRect/BadgesButton.icon = minus_icon
	$ColorRect/UnlockedBadges.visible = !$ColorRect/UnlockedBadges.visible

func _on_CharactersButton_pressed():
	if $ColorRect2.rect_min_size.y == 300:
		$ColorRect2.rect_min_size.y = 40
		$ColorRect2/CharactersButton.icon = plus_icon
	else:
		$ColorRect2.rect_min_size.y = 300
		$ColorRect2/CharactersButton.icon = minus_icon
	$ColorRect2/DisplayCharacterCards.visible = !$ColorRect2/DisplayCharacterCards.visible

func _on_SensorButton_pressed():
	if $ColorRect3.rect_min_size.y == 300:
		$ColorRect3.rect_min_size.y = 40
		$ColorRect3/SensorButton.icon = plus_icon
	else:
		$ColorRect3.rect_min_size.y = 300
		$ColorRect3/SensorButton.icon = minus_icon
		
func _on_ExpandAllButton_pressed():
	$ColorRect.rect_min_size.y = 300
	$ColorRect/UnlockedBadges.visible = true
	
	$ColorRect2.rect_min_size.y = 300
	$ColorRect2/DisplayCharacterCards.visible = true
	
	$ColorRect3.rect_min_size.y = 300


func _on_CollapseAllButton_pressed():
	$ColorRect.rect_min_size.y = 40
	$ColorRect/UnlockedBadges.visible = false
	
	$ColorRect2.rect_min_size.y = 40
	$ColorRect2/DisplayCharacterCards.visible = false
	
	$ColorRect3.rect_min_size.y = 40
