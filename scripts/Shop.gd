extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tide_info = "A tide gauge is a device used to measure the change in sea level relative to the surface of land.\nSensors continuously record the height of the water level by measuring the distance to the water's surface and comparing it to the height of the land it is connected to.\nTide gauges are important sensors when predicting upcoming storms, since storms create higher waves."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_QuitShop_pressed():
	get_parent().remove_child(self)

func _on_CloseInfo_pressed():
	$InformationBox.visible = false



func _on_InfoButton1_pressed():
	$InformationBox.visible = true
	$InformationBox/infoText.bbcode_text = tide_info
