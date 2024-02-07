extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$MoneyInfo.visible = false
	$PopulationInfo.visible = false
	$HappinessInfo.visible = false
	$EconomicGrowthInfo.visible = false
	$WeatherInfo.visible = false
	$TaxesInfo.visible = false


func _on_MoneyInfoButton_mouse_entered():
	$MoneyInfo.visible = true


func _on_MoneyInfoButton_mouse_exited():
	$MoneyInfo.visible = false


func _on_PopulationInfoButton_mouse_entered():
	$PopulationInfo.visible = true


func _on_PopulationInfoButton_mouse_exited():
	$PopulationInfo.visible = false


func _on_HappinessInfoButton_mouse_entered():
	$HappinessInfo.visible = true


func _on_HappinessInfoButton_mouse_exited():
	$HappinessInfo.visible = false


func _on_EconomicGrowthButton_mouse_entered():
	$EconomicGrowthInfo.visible = true


func _on_EconomicGrowthButton_mouse_exited():
	$EconomicGrowthInfo.visible = false


func _on_WeatherPrepButton_mouse_entered():
	$WeatherInfo.visible = true


func _on_WeatherPrepButton_mouse_exited():
	$WeatherInfo.visible = false


func _on_TaxesButton_mouse_entered():
	$TaxesInfo.visible = true


func _on_TaxesButton_mouse_exited():
	$TaxesInfo.visible = false
