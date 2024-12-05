extends Node

const BASE_TILE_VALUE = 5 #How valuable is an empty plot of land?
const GLOBAL_TILE_VALUE_WEIGHT = 20 #Divide calculated value by this number

const WATER_TILE_WEIGHT = 5

const BASE_DIRT_VALUE = 0
const BASE_SAND_VALUE = -10
const BASE_ROCK_VALUE = -10

const LIGHT_RES_VALUE = 1
const HEAVY_RES_VALUE = 1
const COM_VALUE = 0.5
const UTILITIES_PLANT_VALUE = -10
const PARK_VALUE = 3
const ROAD_VALUE = 0

const ZONE_VALUE = 0.1

const PERSON_VALUE = 0.1

const TILE_DAMAGE_WEIGHT = -1

const CITY_WEALTH_WEIGHT = 0.001

const TAX_WEIGHT = -100

const BASE_VALUE = 1.5
func update_land_value():
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			if (Global.tileMap[i][j].is_zoned()):
				var currTile = Global.tileMap[i][j]
				
				#tile value is based on how desirable the land is
				var value = BASE_VALUE * currTile.desirability
				#if the tile is less desirable than an empty plot of land, value gets a penalty
				if currTile.desirability < currTile.BASE_DESIRABILITY:
					value -= .5
				currTile.landValue = value
func update_land_value_tile(currTile):
	if (currTile.is_zoned()):
		#tile value is based on how desirable the land is
		var value = BASE_VALUE * currTile.desirability
		#if the tile is less desirable than an empty plot of land, value gets a penalty
		if currTile.desirability < currTile.BASE_DESIRABILITY:
			value -= .5
		currTile.landValue = value
func calc_presence_of_water(tile): #Return value of nearby water tiles within a radius
	var numWaterTiles = 0
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1], \
					[tile.i-2, tile.j], [tile.i+2, tile.j], [tile.i, tile.j-2], [tile.i, tile.j+2], \
					[tile.i+1, tile.j+1], [tile.i-1, tile.j+1], [tile.i-1, tile.j-1], [tile.i+1, tile.j-1]]
	
	for n in neighbors:
			if is_valid_tile(n[0], n[1]):
				if Global.tileMap[n[0]][n[1]].base == Tile.TileBase.OCEAN:
					numWaterTiles += 1
	
	return numWaterTiles * WATER_TILE_WEIGHT

func calc_tile_base(tile): #Return value of tiles' base type
	var tile_base = tile.base
	match(tile_base):
		Tile.TileBase.DIRT:
			return BASE_DIRT_VALUE
		Tile.TileBase.ROCK:
			return BASE_ROCK_VALUE
		Tile.TileBase.SAND:
			return BASE_ROCK_VALUE
		_:
			pass
	return

func calc_zone_connections(tile): #Return final value of the tiles surrounding selected tile
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1],
			[tile.i-2, tile.j], [tile.i+2, tile.j], [tile.i, tile.j-2], [tile.i, tile.j+2],
			[tile.i+1, tile.j+1], [tile.i-1, tile.j+1], [tile.i-1, tile.j-1], [tile.i+1, tile.j-1]]
	
	var SINGLE_FAMILY_neighbor = 0
	var multi_family_neighbor = 0
	var commercial_neighbor = 0
	var industrial_neighbor = 0
	var park_neighbor = 0
	var road_neighbor = 0
	
	for n in neighbors:
		if is_valid_tile(n[0], n[1]):
			# Check if it's a utility plant
			if Global.tileMap[n[0]][n[1]].inf == Tile.TileInf.UTILITIES_PLANT:
				industrial_neighbor += 1
				continue
			elif Global.tileMap[n[0]][n[1]].inf == Tile.TileInf.PARK:
				park_neighbor += 1
				continue
			elif Global.tileMap[n[0]][n[1]].inf == Tile.TileInf.ROAD:
				road_neighbor += 1
				continue
			
			# Check what type of zone the neighbor is
			var neighbor = Global.tileMap[n[0]][n[1]]
#			
			if neighbor.is_commercial():
				commercial_neighbor += 1
			elif neighbor.get_zone() == Tile.TileZone.SINGLE_FAMILY:
				SINGLE_FAMILY_neighbor += 1
			elif neighbor.get_zone() == Tile.TileZone.MULTI_FAMILY:
				multi_family_neighbor += 1
	
	return (LIGHT_RES_VALUE * SINGLE_FAMILY_neighbor) + \
			(HEAVY_RES_VALUE * multi_family_neighbor) + \
			(COM_VALUE* commercial_neighbor) + \
			(UTILITIES_PLANT_VALUE * industrial_neighbor) + \
			(PARK_VALUE * park_neighbor) + \
			(ROAD_VALUE * road_neighbor)

func calc_num_zones(tile): #Return value number of zones in city
	var numZones = 0
	for i in Global.mapWidth:
		for j in Global.mapHeight:
			var current = Global.tileMap[i][j]
			if current.is_zoned():
				numZones += 1
	return ZONE_VALUE * numZones

func  calc_num_people(tile): #Return value of number of people in city
	return UpdatePopulation.get_population() * PERSON_VALUE

func calc_tile_damage(tile): #Return a value depending on tile damage
	#this returns a value that represents the percentage of damage a tile has
	#this limits happiness to, at most, 100 - the damage of the tile.
	#introducing a cap to happiness that is proportional to damage of the tile
	return tile.tileDamage * 100 #1 is max tile health, so *100 is percentiles

func calc_city_wealth(tile): #Return a value based on city wealth
	var cityWealthValue = 0
	#cityWealthValue = Econ.money * CITY_WEALTH_WEIGHT #TODO: Make this logarithmic?
	return cityWealthValue

func calc_taxation_rate(tile): #Return a weight depending on tax rate of tile
	var cityTaxValue = 0
	
	match(tile.zone):
		Tile.TileZone.SINGLE_FAMILY:
			cityTaxValue = Econ.LIGHT_RES_PROPERTY_RATE + Econ.LIGHT_RES_PROPERTY_RATE
		Tile.TileZone.MULTI_FAMILY:
			cityTaxValue = Econ.HEAVY_RES_PROPERTY_RATE + Econ.HEAVY_RES_PROPERTY_RATE
		Tile.TileZone.COMMERCIAL:
			cityTaxValue = Econ.COM_PROPERTY_RATE + Econ.COM_PROPERTY_RATE
	
	cityTaxValue = cityTaxValue * TAX_WEIGHT
	return cityTaxValue

func is_valid_tile(i, j) -> bool: # Check to see if these indices are valid tile coordinates
	if i < 0 || Global.mapHeight <= i:
		return false
	if j < 0 || Global.mapWidth <= j:
		return false
	return true
