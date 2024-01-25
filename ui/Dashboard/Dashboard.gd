extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect3/CityStatsBar/Money.text = "$" + Econ.comma_values(str(Econ.money))
	$ColorRect3/CityStatsBar/Population.text = str(UpdatePopulation.get_population())
	
func _on_QuitButton_pressed():
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = false
	$QuitButton.material.set_shader_param("value", 1)
	get_parent().remove_child(self)

func _on_QuitButton_button_down():
	$QuitButton.material.set_shader_param("value", 0.1)

func _on_QuitButton_mouse_entered():
	$QuitButton.material.set_shader_param("value", 0.3)

func _on_QuitButton_mouse_exited():
	$QuitButton.material.set_shader_param("value", 1)

func _on_MoneyInfoButton_pressed():
	$ColorRect3/CityStatsBar/MoneyInformation.visible = true


func _on_MoneyInfoButton_button_down():
		$QuitButton.material.set_shader_param("value", 0.1)


func _on_HSlider_value_changed(value):
	pass # Replace with function body.
