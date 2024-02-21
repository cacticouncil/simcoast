extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	#Displays money and population in City Stats Bar
	$ColorRect3/CityStatsBar/Money.text = "$" + Econ.comma_values(str(Econ.money))
	$ColorRect3/CityStatsBar/Population.text = str(UpdatePopulation.get_population())

	#When dashboard is opened, propery, sales, and income taxes are set based on values in Econ.gd
	$ColorRect3/CityStatsBar/HBoxContainer7/PropertyTaxValue.text = str(Econ.PROPERTY_TAX * 100) + "%"
	$ColorRect3/CityStatsBar/HBoxContainer7/PropertyTaxSlider.value = Econ.PROPERTY_TAX
	
	$ColorRect3/CityStatsBar/HBoxContainer8/SalesTaxValue.text = str(Econ.SALES_TAX * 100) + "%"
	$ColorRect3/CityStatsBar/HBoxContainer8/SalesTaxSlider.value = Econ.SALES_TAX
	
	$ColorRect3/CityStatsBar/HBoxContainer9/IncomeTaxValue.text = str(Econ.INCOME_TAX * 100) + "%"
	$ColorRect3/CityStatsBar/HBoxContainer9/IncomeTaxSlider.value = Econ.INCOME_TAX


#quit button functions
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#updates money and population as game continues
	$ColorRect3/CityStatsBar/Money.text = "$" + Econ.comma_values(str(Econ.money))
	$ColorRect3/CityStatsBar/Population.text = str(UpdatePopulation.get_population())
	

#When user adjusts tax sliders, functions are called to change the values in Econ.gd and update the text displayed to the user.
func _on_PropertyTaxSlider_value_changed(value):
	Econ.adjust_property_tax_rate(value)
	$ColorRect3/CityStatsBar/HBoxContainer7/PropertyTaxValue.text = str(Econ.PROPERTY_TAX * 100) + "%"
func _on_SalesTaxSlider_value_changed(value):
	Econ.adjust_sales_tax_rate(value)
	$ColorRect3/CityStatsBar/HBoxContainer8/SalesTaxValue.text = str(Econ.SALES_TAX * 100) + "%"

func _on_IncomeTaxSlider_value_changed(value):
	Econ.adjust_income_tax_rate(value)
	$ColorRect3/CityStatsBar/HBoxContainer9/IncomeTaxValue.text = str(Econ.INCOME_TAX * 100) + "%"
