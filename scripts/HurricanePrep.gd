extends Node


var coastal_defense = 0
var city_hurricane_prep = 0
var beach_rows = Global.beachRows
var beach_cols = Global.mapWidth

func updateHurricanePrep():
	var count = 0
	var totalPrep = 0
	for key in Global.activeTiles:
		#Don't calculate beach rocks or beach grass
		var tile = Global.tileMap[key[0]][key[1]]
		if (tile.inf == Tile.TileInf.BEACH_GRASS || tile.inf == Tile.TileInf.BEACH_ROCKS):
			continue;
		count += 1
		var damage = tile.tileDamage
		var regulationValue = tile.get_building_code_value()
		#var regulationValue = 1 - tile.calculate_building_code_damage_multiplier()
		tile.hurricane_prep = (regulationValue + 1 - damage) / 2
		totalPrep += tile.hurricane_prep
	var avgPerTile = 0
	if (count != 0):
		avgPerTile = totalPrep / count
	coastal_defense = getCoastalDefense()
	#For city
	#Get number of unique sensors and divide by total number of unique sensors (3)
	var sensorValue = 0.0
	if (WindLevel.sensorPresent == true):
		sensorValue += 1
	if (SeaLevel.sensorPresent == true):
		sensorValue += 1
	if (RainLevel.sensorPresent == true):
		sensorValue += 1
	sensorValue = sensorValue / 3
	city_hurricane_prep = (avgPerTile + coastal_defense + sensorValue) / 3
	get_node("/root/CityMap/HUD/HBoxContainer/WeatherPreparedness").text = str(int(city_hurricane_prep * 100)) + "%"
func getCoastalDefense():
	#Number of rock tiles / number of beach tiles
	var numRocks = Beach.item_counts["rock"]
	beach_cols = Global.mapWidth
	beach_rows = Global.beachRows
	var numBeachTiles = (beach_rows[1] + 1 - beach_rows[0]) * beach_cols
	if (numBeachTiles != 0):
		return numRocks / numBeachTiles
	else:
		return 0
