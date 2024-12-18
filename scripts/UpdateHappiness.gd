extends Node

var aggregate = 0
var num_tiles = 0 # Number of tiles that are used to calculate happiness

const BASE_HAPPINESS = 50
const HIGH_UNEMPLOYMENT_PENALTY = -15
const CLOSED_BEACH_PENALTY = -5

func update_happiness():
	# Set the aggregate and num_tiles back to 0
	aggregate = 0
	num_tiles = 0
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
				
				if Global.closeBeach:
					happiness += CLOSED_BEACH_PENALTY
					
				happiness += currTile.desirability * 20
				
				if happiness < 0:
					happiness = 0
				elif happiness > 100:
					happiness = 100
					
				currTile.happiness = happiness
				aggregate += happiness
				num_tiles += 1

func get_average_happiness():
	if num_tiles == 0:
		return 0
	return aggregate / num_tiles
	
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
