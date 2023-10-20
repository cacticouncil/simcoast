extends BTLeaf


# Based on percentages
const UPPER_LIMIT = 0.99
const LOWER_LIMIT = 0.01


# Now that the tile's variable coefficients have been updated, update desirability
func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var tile = blackboard.get_data("queue").pop_front()
	
#	variable representing the influence of a tile's distance to water
	var water = 0
	if (tile.distance_to_water() != null):
#		water weight is 0.025, 0.025 * 6 (max distance tracked) = 0.15, which is the old maximum that water will add to desirability
		water = tile.distance_to_water() * tile.WATER_WEIGHT
		
#	variable representing the influence of a tile's neighbors on its desirability
	var neighbors = tile.residential_neighbors * tile.RESIDENTIAL_NEIGHBOR + tile.commercial_neighbors * tile.COMMERCIAL_NEIGHBOR + \
	tile.industrial_neighbors * tile.INDUSTRIAL_NEIGHBOR + tile.public_works_neighbors * tile.PUBLIC_WORKS_NEIGHBORS
	
# this variable has a negative impact on desirability if the number of zones of each type differs. 
# may need more refinement; a 1-1 relationship between commercial and residential isn't really viable, but under the current 
# system of commercial zones and residential zones having the same 'population' per tile, having fewer commercial zones than 
# residential zones means there aren't enough jobs to go around, so it stays for now
	var zone_balance = abs(Global.numCommercialZones - Global.numResidentialZones) * Global.ZONE_BALANCE
	
	#this variable positively influences desirability the more people there are in the city, up to 100. This means the max
#	impact that this variable can have on desirability is .1. 
	var population = max(UpdatePopulation.get_population(),100) * tile.NUMBER_PEOPLE
	
	#positively impacts desirability if population is growing more rapidly, growth updated monthly
	var growth = UpdatePopulation.get_growth() * UpdatePopulation.GROWTH
	
	 
	# Equation for calculating desirability
	var desirability = tile.BASE_DESIRABILITY + \
		int(tile.is_close_water) * tile.WATER_CLOSE + \
		int(tile.is_far_water) * tile.WATER_FAR + \
		int(tile.tile_base_dirt) * tile.BASE_DIRT + int(tile.tile_base_rock) * tile.BASE_ROCK + int(tile.tile_base_sand) * tile.BASE_SAND + \
		tile.residential_neighbors * tile.RESIDENTIAL_NEIGHBOR + tile.commercial_neighbors * tile.COMMERCIAL_NEIGHBOR + tile.industrial_neighbors * tile.INDUSTRIAL_NEIGHBOR + \
		Global.numZones * tile.NUMBER_ZONES + Global.numPeople * tile.NUMBER_PEOPLE + \
		int(tile.is_sales_tax_heavy) * tile.SALES_TAX_HEAVY + \
		tile.prop_tax_weight + \
		int(tile.is_neg_profit) * tile.WEALTH_NEG + \
		tile.wealth_weight * tile.WEALTH_DESIRE + \
		tile.tile_dmg_weight
		
	if desirability > UPPER_LIMIT:
		desirability = UPPER_LIMIT
	elif desirability < LOWER_LIMIT:
		desirability = LOWER_LIMIT
		
	tile.desirability = desirability
	
	check_empty(blackboard)
	
	return succeed()


# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue").empty()
	if empty:
		blackboard.set_data("queue_empty", true)
