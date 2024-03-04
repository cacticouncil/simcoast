extends VBoxContainer

var info_button = preload("res://assets/buttons/info_button.png")
var info_button_hover = preload("res://assets/buttons/info_button_hover.png")

#This script handles popup functionality for descriptions of stats in sidebar of dashboard.
#Info popups are only visible upon mouse hover. Each button has a mouse entered and exited function
#to display text and hide it respectively. Hover state also alters icon color.

#Info not visible by default.
func _ready():
	$MoneyInfo.visible = false
	$PopulationInfo.visible = false
	$HappinessInfo.visible = false
	$EconomicGrowthInfo.visible = false
	$WeatherInfo.visible = false
	$TaxesInfo.visible = false


func _on_MoneyInfoButton_mouse_entered():
	$MoneyInfo.visible = true
	$HBoxContainer/MoneyInfoButton.icon = info_button_hover
func _on_MoneyInfoButton_mouse_exited():
	$MoneyInfo.visible = false
	$HBoxContainer/MoneyInfoButton.icon = info_button


func _on_PopulationInfoButton_mouse_entered():
	$PopulationInfo.visible = true
	$HBoxContainer2/PopulationInfoButton.icon = info_button_hover
func _on_PopulationInfoButton_mouse_exited():
	$PopulationInfo.visible = false
	$HBoxContainer2/PopulationInfoButton.icon = info_button


func _on_HappinessInfoButton_mouse_entered():
	$HappinessInfo.visible = true
	$HBoxContainer3/HappinessInfoButton.icon = info_button_hover
func _on_HappinessInfoButton_mouse_exited():
	$HappinessInfo.visible = false
	$HBoxContainer3/HappinessInfoButton.icon = info_button


func _on_EconomicGrowthButton_mouse_entered():
	$EconomicGrowthInfo.visible = true
	$HBoxContainer4/EconomicGrowthButton.icon = info_button_hover
func _on_EconomicGrowthButton_mouse_exited():
	$EconomicGrowthInfo.visible = false
	$HBoxContainer4/EconomicGrowthButton.icon = info_button


func _on_WeatherPrepButton_mouse_entered():
	$WeatherInfo.visible = true
	$HBoxContainer5/WeatherPrepButton.icon = info_button_hover
func _on_WeatherPrepButton_mouse_exited():
	$WeatherInfo.visible = false
	$HBoxContainer5/WeatherPrepButton.icon = info_button


func _on_TaxesButton_mouse_entered():
	$TaxesInfo.visible = true
	$HBoxContainer6/TaxesButton.icon = info_button_hover
func _on_TaxesButton_mouse_exited():
	$TaxesInfo.visible = false
	$HBoxContainer6/TaxesButton.icon = info_button
