extends BTLeaf


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
	match tile.get_zone():
		Tile.TileZone.LIGHT_COMMERCIAL:
			pass
		Tile.TileZone.HEAVY_COMMERCIAL:
			pass
		Tile.TileZone.LIGHT_RESIDENTIAL:
			pass
		Tile.TileZone.HEAVY_RESIDENTIAL:
			pass
		_: 
		
	return succeed()
