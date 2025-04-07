extends Node

const BASE_HAPPINESS = 0.5
const HIGH_UNEMPLOYMENT_PENALTY = -0.15
var city_happiness = 0

func update_happiness():
	var totalHappiness = 0
	var numResTiles = 0
	for tile in Global.activeTiles:
		var currTile = Global.tileMap[tile[0]][tile[1]]
		#If there are people in the tile
		if (currTile.is_zoned() && currTile.data[2] != 0):
			var avgHappiness = currTile.calculateHappiness()
			var happiness = (avgHappiness + currTile.desirability) / 2
			#if unemployment is high, happiness takes a big hit
			if UpdatePopulation.is_unemployment_high():
				happiness += HIGH_UNEMPLOYMENT_PENALTY
			currTile.happiness = happiness * 100
			numResTiles += 1
		totalHappiness += currTile.happiness
	if (numResTiles == 0):
		city_happiness = 0
		return
	city_happiness = (totalHappiness / numResTiles) * 0.01
	get_node("/root/CityMap/HUD/HBoxContainer/Happiness").text = str(int(city_happiness * 100)) + "%"
	#print(city_happiness)
func update_happiness_tile(currTile):
	#If there are people in the tile
	if (currTile.is_zoned() && currTile.data[2] != 0):
		var avgHappiness = currTile.calculateHappiness()
		var happiness = (avgHappiness + currTile.desirability) / 2
		#if unemployment is high, happiness takes a big hit
		if UpdatePopulation.is_unemployment_high():
			happiness += HIGH_UNEMPLOYMENT_PENALTY
		currTile.happiness = happiness * 100
