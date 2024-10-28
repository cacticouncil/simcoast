extends Node

const BASE_HAPPINESS = 50
const HIGH_UNEMPLOYMENT_PENALTY = -15

func update_happiness():
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			if (Global.tileMap[i][j].is_zoned() && Global.tileMap[i][j].data[2] != 0):
				var currTile = Global.tileMap[i][j]
				var happiness = BASE_HAPPINESS
				
				var waterValue = UpdateValue.calc_presence_of_water(currTile)
				var zoneConnectionsValue = UpdateValue.calc_zone_connections(currTile)
				var tileDamageValue = UpdateValue.calc_tile_damage(currTile)
				var taxRateValue = UpdateValue.calc_taxation_rate(currTile)
				
				#if unemployment is high, happiness takes a big hit
				if UpdatePopulation.is_unemployment_high():
					happiness += HIGH_UNEMPLOYMENT_PENALTY
				
				happiness = happiness + waterValue + zoneConnectionsValue + taxRateValue - tileDamageValue
				
				if happiness < 0:
					happiness = 0
				elif happiness > 100:
					happiness = 100
					
				currTile.happiness = happiness
func update_happiness_tile(currTile):
	if (currTile.is_zoned() && currTile.data[2] != 0):
		var happiness = BASE_HAPPINESS
		var waterValue = UpdateValue.calc_presence_of_water(currTile)
		var zoneConnectionsValue = UpdateValue.calc_zone_connections(currTile)
		var tileDamageValue = UpdateValue.calc_tile_damage(currTile)
		var taxRateValue = UpdateValue.calc_taxation_rate(currTile)
				
		#if unemployment is high, happiness takes a big hit
		if UpdatePopulation.is_unemployment_high():
			happiness += HIGH_UNEMPLOYMENT_PENALTY
				
		happiness = happiness + waterValue + zoneConnectionsValue + taxRateValue - tileDamageValue
				
		if happiness < 0:
			happiness = 0
		elif happiness > 100:
			happiness = 100
					
		currTile.happiness = happiness
