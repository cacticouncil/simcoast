extends PopupPanel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	popup_exclusive = true


func _on_MoneyInfoButton_pressed():
	visible = !visible

