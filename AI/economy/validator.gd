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
# distance to water returns null if no water within 6 tiles
# abs statement flips it so closer water is more influential than farther water, with a minimum of 1
		water = abs(tile.distance_to_water()-5) * tile.WATER_WEIGHT
		
#	variable representing the influence of a tile's neighbors on its desirability
	var neighbors = tile.residential_neighbors * tile.RESIDENTIAL_NEIGHBOR + tile.commercial_neighbors * tile.COMMERCIAL_NEIGHBOR + \
	tile.industrial_neighbors * tile.INDUSTRIAL_NEIGHBOR + tile.get_public_works_value()
	
# this variable has a negative impact on desirability if the number of zones of each type differs. 
# may need more refinement; a 1-1 relationship between commercial and residential isn't really viable, but under the current 
# system of commercial zones and residential zones having the same 'population' per tile, having fewer commercial zones than 
# residential zones means there aren't enough jobs to go around, so it stays for now
	var zone_balance = abs(City.numCommercialZones - City.numResidentialZones) * Global.ZONE_BALANCE
	
	#this variable positively influences desirability the more people there are in the city, up to 100. This means the max
#	impact that this variable can have on desirability is .1. 
	var population = min(UpdatePopulation.get_population(),100) * tile.NUMBER_PEOPLE
	
	#positively impacts desirability if population is growing more rapidly, growth updated monthly
	var growth = UpdatePopulation.get_growth() * tile.GROWTH
	
	#measures the positive or negative impact of the tax structure. high taxes -> negative impact, low taxes -> positive impact, neutral taxes -> no impact
	#neutral taxes are meant to convey that the taxes here are no higher or lower than another comparable place, so they don't influence people wanting to be here
	#only one of the three booleans will be nonzero
	var sales_tax = int(tile.is_sales_tax_light) * Tile.SALES_TAX_LIGHT + int(tile.is_sales_tax_neutral) * Tile.SALES_TAX_NEUTRAL + int(tile.is_sales_tax_heavy) * Tile.SALES_TAX_HEAVY
	var property_tax = int(tile.is_prop_tax_light) * Tile.PROP_TAX_LIGHT + int(tile.is_prop_tax_neutral) * Tile.PROP_TAX_NEUTRAL + int(tile.is_prop_tax_heavy) * Tile.PROP_TAX_HEAVY
	var income_tax = int(tile.is_income_tax_light) * Tile.INCOME_TAX_LIGHT + int(tile.is_income_tax_neutral) * Tile.INCOME_TAX_NEUTRAL + int(tile.is_income_tax_heavy) * Tile.INCOME_TAX_HEAVY
#	tax_burden represents the total impact of all three types of taxes on desirability
	var tax_burden = sales_tax + property_tax + income_tax
	
	#this value represents how a tile's wealth impacts its desirability. Tiles with higher wealth will have higher desirability
	#commercial tile wealth is impacted by the wealth of the residential zones around it
	#see city_wealth.gd for more
	var wealth_influence = tile.wealth_weight * tile.WEALTH_INFLUENCE
	
	#tile_dmg_weight is a value that subtracts from desirability if a tile is damaged, doesn't add anything only removes
	#desirability explains itself in the name, and is influenced by all the factors defined above
	#single family zones are very desirable, so they have a different base desirability than everyone else
	var desirability = 0
	if (tile.zone == Tile.TileZone.SINGLE_FAMILY):
		desirability = tile.BASE_SINGLE_FAMILY_DESIRABILITY + water + neighbors + zone_balance + population + growth + tax_burden + wealth_influence + tile.tile_dmg_weight
	else:
		desirability = tile.BASE_DESIRABILITY + water + neighbors + zone_balance + population + growth + tax_burden + wealth_influence + tile.tile_dmg_weight

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
