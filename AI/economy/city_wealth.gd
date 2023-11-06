extends BTLeaf

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var tile = blackboard.get_data("queue").front()
	
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
		
