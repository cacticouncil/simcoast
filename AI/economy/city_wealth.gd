extends BTLeaf

#var avg_income = 0
#var avg_profit = 0
# What is the city income? Proportionate to number of zones
func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var tile = blackboard.get_data("queue").front()
#	var avgIncome = Econ.calcCityIncome()
#	if tile.profitRate < 0:
#		tile.is_neg_profit = true
#	elif tile.profitRate < avgIncome - 1000:
#		tile.wealth_weight = 0
#	elif avgIncome - 1000 <= tile.profitRate && tile.profitRate < avgIncome:
#		tile.wealth_weight = 1
#	elif avgIncome <= tile.profitRate && tile.profitRate < avgIncome + 1000:
#		tile.wealth_weight = 2
#	else:
#		tile.wealth_weight = 4
#	var total_income = 0
#	var total_profit = 0
#	var res_tiles = 0
#	var com_tiles = 0
#	#update the profit rate for all tiles and calc avg residential income and avg commercial profit
#	for x in Global.mapHeight:
#		for y in Global.mapWidth:
#			if is_valid_tile(x, y):
#				var currTile = Global.tileMap[x][y]
#				#city profit for res tiles is based on how many people are there and how many houses
#				if currTile.is_residential():
#					currTile.profitRate = (currTile.data[2] * UpdatePopulation.BASE_EMPLOYMENT_RATE * \
#					Econ.INCOME_TAX + currTile.data[0] * Econ.PROPERTY_TAX) * \
#					Econ.TAX_INCOME_MULTIPLIER * currTile.landValue
#					total_income += currTile.profitRate
#					print("res: ", currTile.profitRate)
#					res_tiles += 1
#				#commercial zones generate revenue via sales tax and property tax, 
#				#scaling how much sales tax based on the income of their surrounding area
#				if currTile.is_commercial():
#					currTile.profitRate = (avg_income_around_tile(currTile.i, currTile.j) * Econ.SALES_TAX) * \
#					(UpdatePopulation.get_population() / Global.numCommercialZones) + \
#					tile.data[0] * Econ.PROPERTY_TAX * Econ.TAX_INCOME_MULTIPLIER * currTile.landValue
#					#the population bit is to help commercial profit scale with population
#					# it basically assumes that people will patronize all commercial zones equally
#					total_profit += currTile.profitRate
#					print("com: ", currTile.profitRate)
#					com_tiles += 1
#
#	#avg income now represents the average tax revenue from the incomes of the employed people 
#	#in the city and the value of the houses where they live
#	if (res_tiles != 0):
#		avg_income = total_income / res_tiles
#	#avg_profit represents the average amount of money a commercial tile makes in the city
#	if (com_tiles != 0):
#		avg_profit = total_profit / com_tiles
	
	#wealth weights are set based on how far the income deviates from the average			
	match tile.get_zone():
		Tile.TileZone.LIGHT_COMMERCIAL:
			#high negative influence if tile is losing money
			if tile.profitRate < 0:
				tile.wealth_weight = -2
			#mild negative influence if tile is below average but still green
			elif tile.profitRate < Econ.avg_profit - 1000:
				tile.wealth_weight = -1
			#mild positive influence if tile is around the average
			elif Econ.avg_profit - 1000 < tile.profitRate && tile.profitRate < Econ.avg_profit + 1000:
				tile.wealth_weight = 1
			#high positive influence if tile is above average
			else:
				tile.wealth_weight = 2 
		Tile.TileZone.HEAVY_COMMERCIAL:
			if tile.profitRate < 0:
				tile.wealth_weight = -2
			elif tile.profitRate < Econ.avg_profit - 1000:
				tile.wealth_weight = -1
			elif Econ.avg_profit - 1000 < tile.profitRate && tile.profitRate < Econ.avg_profit + 1000:
				tile.wealth_weight = 1
			else:
				tile.wealth_weight = 2 
		Tile.TileZone.LIGHT_RESIDENTIAL:
			if tile.profitRate < 0:
				tile.wealth_weight = -2
			elif tile.profitRate < Econ.avg_income - 1000:
				tile.wealth_weight = -1
			elif Econ.avg_income - 1000 < tile.profitRate && tile.profitRate < Econ.avg_income + 1000:
				tile.wealth_weight = 1
			else:
				tile.wealth_weight = 2 
		Tile.TileZone.HEAVY_RESIDENTIAL:
			if tile.profitRate < 0:
				tile.wealth_weight = -2
			elif tile.profitRate < Econ.avg_income - 1000:
				tile.wealth_weight = -1
			elif Econ.avg_income - 1000 < tile.profitRate && tile.profitRate < Econ.avg_income + 1000:
				tile.wealth_weight = 1
			else:
				tile.wealth_weight = 2 
		
	return succeed()

#copied from presence_of_water.gd for use in above function as a helper
func is_valid_tile(i, j) -> bool:
	if i < 0 || Global.mapHeight <= i:
		return false
	if j < 0 || Global.mapWidth <= j:
		return false
	return true

#calculates the average income in residential zones in a circle radius around a given tile
func avg_income_around_tile(i, j):
	var total_income = 0
	var res_tiles = 0
	var local_avg_income = 0
	if is_valid_tile(i, j):
		var tile = Global.tileMap[i][j]
		for x in range(tile.i-1, tile.i+2):
			for y in range(tile.j-1, tile.j+2):
				if is_valid_tile(x, y):
					var currTile = Global.tileMap[x][y]
					if currTile.is_residential():
						var tile_income = (currTile.data[2] * UpdatePopulation.BASE_EMPLOYMENT_RATE * \
						Econ.INCOME_TAX + currTile.data[0] * Econ.PROPERTY_TAX) * \
						Econ.TAX_INCOME_MULTIPLIER * currTile.landValue
						total_income += tile_income
						res_tiles += 1
		if res_tiles != 0:
			local_avg_income = total_income / res_tiles
	return local_avg_income
		
