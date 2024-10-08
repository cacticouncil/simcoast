extends CanvasLayer

var base_values = {
	Tile.TileBase.DIRT: "Dirt",
	Tile.TileBase.ROCK: "Rock",
	Tile.TileBase.SAND: "Sand",
	Tile.TileBase.OCEAN: "Ocean"
}

var zone_values = {	
	Tile.TileZone.NONE: "None",
	Tile.TileZone.SINGLE_FAMILY: "Single Family",
	Tile.TileZone.MULTI_FAMILY: "Multi Family",
	Tile.TileZone.COMMERCIAL: "Commercial",
	Tile.TileZone.PUBLIC_WORKS: "Public Works"
}

var inf_values = {
	Tile.TileInf.NONE: "None",
	Tile.TileInf.ROAD: "Road",
	Tile.TileInf.PARK: "Park",
	Tile.TileInf.BUILDING: "Building"
}

var damage_values = {
	Tile.TileStatus.NONE: "None",
	Tile.TileStatus.LIGHT_DAMAGE: "Light Damage",
	Tile.TileStatus.MEDIUM_DAMAGE: "Medium Damage",
	Tile.TileStatus.HEAVY_DAMAGE: "Heavy Damage"
}

func update_tile_display(i, j):
	var tile = Global.tileMap[i][j]
	$BottomBar/HoverText.text = "(%s, %s)" % [i, j]
	$BottomBar/HoverText.text += "     BASE: %s     HEIGHT: %s     WATER HEIGHT %s     EROSION: %s%%" % [base_values[tile.get_base()], tile.get_base_height(), tile.waterHeight, tile.erosion]
	if tile.get_zone() != Tile.TileZone.NONE:
		if tile.get_zone() == Tile.TileZone.PUBLIC_WORKS:
			$BottomBar/HoverText.text += "     Zone: %s, Tile Damage: %s%%" % [zone_values[tile.get_zone()], tile.tileDamage*100]
		else:
			$BottomBar/HoverText.text += "     Zone: %s, People: %s / %s, Tile Damage: %s%%, Happiness: %s%%, Desirability: %s" % [zone_values[tile.get_zone()], tile.data[2], tile.data[3], tile.tileDamage*100, tile.happiness, tile.desirability]
		if tile.utilities:
			$BottomBar/HoverText.text += "     Utilities: ON"
		else:
			$BottomBar/HoverText.text += "     Utilities: OFF"
	elif tile.inf == Tile.TileInf.ROAD || tile.inf == Tile.TileInf.BRIDGE || tile.inf == Tile.TileInf.BOARDWALK:
		if tile.utilities:
			$BottomBar/HoverText.text += "     Utilities: ON"
		else:
			$BottomBar/HoverText.text += "     Utilities: OFF"
		$BottomBar/HoverText.text += "     Tile Damage: %s%%" % [tile.tileDamage*100]
	if tile.get_sensor() == Tile.TileSensor.TIDE:
		$BottomBar/HoverText.text += "     Sensor: Tide"
		if (tile.sensor_active):
			$BottomBar/HoverText.text += "     Status: ACTIVE"
			$BottomBar/HoverText.text += "     Sea Level: %s mm" % [SeaLevel.currentSeaLevel]
		else:
			$BottomBar/HoverText.text += "     Status: INACTIVE"
	if tile.get_sensor() == Tile.TileSensor.RAIN:
		$BottomBar/HoverText.text += "     Sensor: Rain"
		if (tile.sensor_active):
			$BottomBar/HoverText.text += "     Status: ACTIVE"
			$BottomBar/HoverText.text += "     Rain Level: %s mm" % [RainLevel.currentRainLevel]
		else:
			$BottomBar/HoverText.text += "     Status: INACTIVE"
	if tile.get_sensor() == Tile.TileSensor.WIND:
		$BottomBar/HoverText.text += "     Sensor: Wind"
		if (tile.sensor_active):
			$BottomBar/HoverText.text += "     Status: ACTIVE"
			$BottomBar/HoverText.text += "     Wind Level: %s mps" % [WindLevel.currentWindLevel]
		else:
			$BottomBar/HoverText.text += "     Status: INACTIVE"
