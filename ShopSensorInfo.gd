extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hey Hey Hey!")
	$InfoBox.visible = true
	for sensor in Inventory.sensors:
		if sensor.get_name() == Inventory.current_sensor:
			$InfoBox/InfoText.text = sensor.get_ext_info()

func _on_InfoClose_pressed():
	get_parent().remove_child(self)

