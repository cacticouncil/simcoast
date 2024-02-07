extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ScrollContainer/VBoxContainer.add_constant_override("separation", 6)
	$ScrollContainer/VBoxContainer/ColorRect/UnlockedBadges.visible = false
	$ScrollContainer/VBoxContainer/ColorRect2/DisplayCharacterCards.visible = false
	
func _on_BadgesButton_pressed():
	if $ScrollContainer/VBoxContainer/ColorRect.rect_min_size.y == 300:
		$ScrollContainer/VBoxContainer/ColorRect.rect_min_size.y = 40
	else:
		$ScrollContainer/VBoxContainer/ColorRect.rect_min_size.y = 300
	$ScrollContainer/VBoxContainer/ColorRect/UnlockedBadges.visible = !$ScrollContainer/VBoxContainer/ColorRect/UnlockedBadges.visible

func _on_CharactersButton_pressed():
	if $ScrollContainer/VBoxContainer/ColorRect2.rect_min_size.y == 300:
		$ScrollContainer/VBoxContainer/ColorRect2.rect_min_size.y = 40
	else:
		$ScrollContainer/VBoxContainer/ColorRect2.rect_min_size.y = 300
	$ScrollContainer/VBoxContainer/ColorRect2/DisplayCharacterCards.visible = !$ScrollContainer/VBoxContainer/ColorRect2/DisplayCharacterCards.visible

func _on_SensorButton_pressed():
	if $ScrollContainer/VBoxContainer/ColorRect3.rect_min_size.y == 300:
		$ScrollContainer/VBoxContainer/ColorRect3.rect_min_size.y = 40
	else:
		$ScrollContainer/VBoxContainer/ColorRect3.rect_min_size.y = 300


