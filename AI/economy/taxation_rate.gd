extends BTLeaf

const avg_property_tax_rate = 0.008
#between 0.5 and 1.5% prop tax is neutral
const avg_sales_tax = 0.07
var avg_tax_rate = Econ.BASE_TAX_RATE

const heavy_prop_tax = 0.015 #1.5% prop tax and above is heavy
const light_prop_tax = 0.005 #0.5% prop tax and below is light
#between 0.5 and 1.5% prop tax is neutral

const heavy_sales_tax = 0.07 #sales tax above 7% is heavy
const light_sales_tax = 0.04 #sales tax below 4% is light
#between 4% and 7% sales tax is neutral

const heavy_income_tax = 0.03 #income tax above 3% is heavy
const light_income_tax = 0.02 #income tax below 2% is light
#between 2 and 3% income tax is neutral

# Tax rates change how valuable a zone is through a negative relationship
func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var tile = blackboard.get_data("queue").front()
#determining if the property tax is heavy, light, or neutral, and setting booleans accordingly
	if light_prop_tax > Econ.PROPERTY_TAX:
		tile.is_prop_tax_heavy = false
		tile.is_prop_tax_neutral = false
		tile.is_prop_tax_light = true
	elif Econ.PROPERTY_TAX > heavy_prop_tax:
		tile.is_prop_tax_heavy = true
		tile.is_prop_tax_neutral = false
		tile.is_prop_tax_light = false
	else:
		tile.is_prop_tax_heavy = false
		tile.is_prop_tax_neutral = true
		tile.is_prop_tax_light = false
		
	#determining if the sales tax is heavy, light, or neutral, and setting booleans accordingly
	if light_sales_tax > Econ.SALES_TAX:
		tile.is_sales_tax_heavy = false
		tile.is_sales_tax_neutral = false
		tile.is_sales_tax_light = true
	elif Econ.SALES_TAX > heavy_sales_tax:
		tile.is_sales_tax_heavy = true
		tile.is_sales_tax_neutral = false
		tile.is_sales_tax_light = false
	else:
		tile.is_sales_tax_heavy = false
		tile.is_sales_tax_neutral = true
		tile.is_sales_tax_light = false
		
	#determining if the income tax is heavy, light, or neutral, and setting booleans accordingly
	if light_income_tax > Econ.INCOME_TAX:
		tile.is_income_tax_heavy = false
		tile.is_income_tax_neutral = false
		tile.is_income_tax_light = true
	elif Econ.INCOME_TAX > heavy_income_tax:
		tile.is_income_tax_heavy = true
		tile.is_income_tax_neutral = false
		tile.is_income_tax_light = false
	else:
		tile.is_income_tax_heavy = false
		tile.is_income_tax_neutral = true
		tile.is_income_tax_light = false
	return succeed()
