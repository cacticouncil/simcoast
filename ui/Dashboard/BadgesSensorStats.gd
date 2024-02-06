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
	$ScrollContainer/VBoxContainer/ColorRect.rect_min_size.y = 300
	$ScrollContainer/VBoxContainer/ColorRect2.rect_min_size.y = 300
	$ScrollContainer/VBoxContainer/ColorRect3.rect_min_size.y = 300	
	$ScrollContainer/VBoxContainer/ColorRect/UnlockedBadges.visible = true
	$ScrollContainer/VBoxContainer/ColorRect2/DisplayCharacterCards.visible = true


