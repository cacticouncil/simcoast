# Tile data object which stores properties about each tile cube

extends Object

class_name Tile

enum TileBase {
	DIRT,
	SAND,
	OCEAN,
	ROCK
}

enum TileZone {
	NONE,
	SINGLE_FAMILY,
	MULTI_FAMILY,
	COMMERCIAL,
	PUBLIC_WORKS
}

enum TileInf {
	NONE,
	ROAD,
	BRIDGE,
	BOARDWALK,
	PARK,
	FIRE_STATION,
	HOSPITAL,
	POLICE_STATION,
	LIBRARY,
	MUSEUM,
	SCHOOL,
	HOUSE,
	BUILDING,
	BEACH_ROCKS,
	BEACH_GRASS,
	UTILITIES_PLANT,
	SEWAGE_FACILITY,
	WASTE_TREATMENT,
	WAVE_BREAKER,
	CHILD
}

enum TileSensor {
	NONE,
	TIDE,
	RAIN,
	WIND
}

# Flooding damage levels affect building and road tiles
# Wear and tear damage on tiles affect utilities/road connections
enum TileStatus {
	NONE,
	LIGHT_DAMAGE,
	MEDIUM_DAMAGE,
	HEAVY_DAMAGE
}

const DIRT_COLOR = [Color("ffc59d76"), Color("ffbb8d5d"), Color("ff9e7758"), Color("ff666666")]
const GRASS_COLOR = [Color("ff8bb54a"), Color("ff60822d")]
const SAND_COLOR = [Color("ffd9d3bf"), Color("ffc9bf99"), Color("ffaca075"), Color("ff867d5e")]
const WATER_COLOR = [Color("ff9cd5e2"), Color("ff8bc4d1"), Color("ff83bcc9"), Color("ff5b8c97")]
const ROCK_COLOR = [Color("ffc2c2c2"), Color("ffcacaca"), Color("ffaaaaaa"), Color("ff666666")]

const SINGLE_FAMILY_ZONE_COLOR = [Color("ffbdd0a0"), Color("ff60822d")]
const MULTI_FAMILY_ZONE_COLOR = [Color("ffa5bf7d"), Color("ff60822d")]
#const LT_COM_ZONE_COLOR = [Color("ffa0b4d0"), Color("ff2d5b82")]
const COM_ZONE_COLOR = [Color("ff7d9bbf"), Color("ff2d5b82")]

const BUILDING_COLOR = [Color("ffaaaaaa"), Color("ff999999"), Color("ff888888"), Color("ff777777")]
const NO_UTILITIES_BUILDING_COLOR = [Color("ff555555"), Color("ff444444"), Color("ff333333"), Color("ff333333")]

const UTILITIES_PLANT_COLOR = [Color("ff777777"), Color("ff888888"), Color("ff999999"), Color("ff999999")]
const UTILITIES_STACK_COLOR = [Color("ff333333"), Color("ff950000"), Color("ff6a0000"), Color("ff333333")]
const SEWAGE_FACILITY_COLOR = [Color("ff4d2817"), Color("ff663a24"), Color("ff945535"), Color("ff945535")]
const WASTE_TREATMENT_COLOR = [Color("ff1f5922"), Color("ff3b943f"), Color("ff54d15a"), Color("ff54d15a")]

const RES_OCCUPANCY_COLOR = [Color("aa2a9d2d"), Color("aa1d851f")]
const COM_OCCUPANCY_COLOR = [Color("aa3779a2"), Color("aa26648b")]

const LIGHT_DAMAGE_COLOR = [Color("ff555555"), Color("ffd8bf09"), Color("ffc4ae00"), Color("ffae9a00")]
const MEDIUM_DAMAGE_COLOR = [Color("ff555555"), Color("ffd86909"), Color("ffac5100"), Color("ffac5100")]
const HEAVY_DAMAGE_COLOR = [Color("ff555555"), Color("ffd80909"), Color("ff7c0000"), Color("ff590000")]

const FIRE_STATION_COLOR = [Color("ff5e2821"), Color("ffa85145"), Color("fffc7462"), Color("fffc7462")]
const HOSPITAL_COLOR = [Color("ff5c5c5c"), Color("ffb0b0b0"), Color("fffafafa"), Color("fffafafa")]
const POLICE_STATION_COLOR = [Color("ff22246b"), Color("ff3d40a1"), Color("ff5f64fa"), Color("ff5f64fa")]
const PARK_COLOR = [Color("ff8bb54a"), Color("ff60822d")]
const TREE_COLOR = [Color("ff4a8a7d"), Color("ff286f61")]
const LIBRARY_COLOR = [Color("ff666333"), Color("ff9c984c"), Color("ffe0db72"), Color("ffe0db72")]
const MUSEUM_COLOR = [Color("ff6e472d"), Color("ffa8724d"), Color("fff7a66f"), Color("fff7a66f")]
const SCHOOL_COLOR = [Color("ff45196e"), Color("ff6f31a8"), Color("ffa94dff"), Color("ffa94dff")]
const BEACH_ROCK_COLOR = [Color("ffb8c5d4"), Color("ffa0b3cc"), Color("ff8ca4c0")]

const ROAD_COLOR = [Color("ff6a6a6a"), Color("ff999999")]
const BRIDGE_COLOR = [Color("ff6a6a6a"), Color("ff999999")]

var i
var j
var baseHeight = 0
var waterHeight = 0
var bridgeHeight = 0
var wearAndTear = 0
var base = 0
var zone = 0
var inf = 0
var cube = Area2D.new()
var data = [0, 0, 0, 0, TileStatus.NONE]
var utilities = false
var tileDamage = 0
var erosion = 0
# Purchase price of a tile
var landValue = 0
# Income of a zone
var profitRate = 0
var happiness = 0
var changeInWaterHeight = 0
var changeInWearAndTear = false
# Tracks what connections a tile has to its neighbors with roads
var connections = [0,0,0,0]
var sensor = TileSensor.NONE
var sensor_active = false
# Economy AI: equation coefficient constants
var desirability = 0.2
const BASE_DESIRABILITY = 0.2
const BASE_SINGLE_FAMILY_DESIRABILITY = 0.4
const WATER_CLOSE = 0.1
const WATER_FAR = 0.05
const WATER_WEIGHT = 0.025
const BASE_DIRT = 0.05
const BASE_ROCK = 0
const BASE_SAND = -0.05
const RESIDENTIAL_NEIGHBOR = 0.05
const COMMERCIAL_NEIGHBOR = 0.10
const INDUSTRIAL_NEIGHBOR = -0.2
const PUBLIC_WORKS_NEIGHBORS = 0.075
const PARK_NEIGHBORS = 0.1
const LIBRARY_NEIGHBORS = 0.2
const MUSEUM_NEIGHBORS = 0.2
const SCHOOL_NEIGHBORS = 0.2

#These 3 give a one time boost
const FIRE_STATION_NEIGHBORS = 0.3
const POLICE_STATION_NEIGHBORS = 0.3
const HOSPITAL_NEIGHBORS = 0.3

const NUMBER_ZONES = 0.01
const NUMBER_PEOPLE = 0.001
const PROP_TAX_HEAVY = -0.1
const PROP_TAX_NEUTRAL = 0
const PROP_TAX_LIGHT = 0.05
const SALES_TAX_HEAVY = -0.05
const SALES_TAX_NEUTRAL = 0
const SALES_TAX_LIGHT = .025
const INCOME_TAX_HEAVY = -.15
const INCOME_TAX_NEUTRAL = 0
const INCOME_TAX_LIGHT = 0.075
const WEALTH_INFLUENCE = 0.05
const GROWTH = .001


# Economy AI: Equation variable booleans & values
var is_close_water = false
var is_far_water = false
var bridge_connected_to_dirt = false
var tile_base_dirt = false
var tile_base_rock = false
var tile_base_sand = false

var on_beach = false
var pre_evacuation_residents = -1

var residential_neighbors = 0
var commercial_neighbors = 0
var industrial_neighbors = 0
var public_works_dictionary = {
	"parks": 0,
	"libraries": 0,
	"museums": 0,
	"school": 0,
	"fire_stations": 0,
	"hospitals": 0,
	"police_stations": 0
}
var prop_tax_weight = 0
var is_sales_tax_heavy = false
var is_sales_tax_neutral = false
var is_sales_tax_light = false
var is_prop_tax_heavy = false
var is_prop_tax_neutral = false
var is_prop_tax_light = false
var is_income_tax_heavy = false
var is_income_tax_neutral = false
var is_income_tax_light = false
var is_neg_profit = false
var wealth_weight = 0
var tile_dmg_weight = 0
var num_beach_rocks_nearby = 0
var children = [] #List of List of children's indicies
var parent = [-1, -1] #If this tile is a child, this is it's parent, otherwise -1, -1


func _init(tileData):
	if not tileData.empty():
		for key in tileData:
			if key == "zone":
				self.set(key, convert_string_to_zone(tileData[key]))
			elif key == "base":
				self.set(key, convert_string_to_base(tileData[key]))
			elif key == "inf":
				self.set(key, convert_string_to_inf(tileData[key]))
			elif key == "sensor":
				self.set(key, convert_string_to_sensor(tileData[key]))
			elif key == "data":
				data = tileData[key]
				data[4] = convert_string_to_tile_status(tileData[key][4])
			else:
				self.set(key, tileData[key])


func convert_string_to_zone(zone):
	match zone:
		"none":
			return TileZone.NONE
		"single_family":
			return TileZone.SINGLE_FAMILY
		"multi_family":
			return TileZone.MULTI_FAMILY
		"commercial":
			return TileZone.COMMERCIAL
		"public_works":
			return TileZone.PUBLIC_WORKS


func convert_string_to_base(base):
	match base:
		"dirt":
			return TileBase.DIRT
		"sand":
			return TileBase.SAND
		"ocean":
			return TileBase.OCEAN
		"rock":
			return TileBase.ROCK


func convert_string_to_inf(inf):
	match inf:
		"none":
			return TileInf.NONE
		"road":
			return TileInf.ROAD
		"bridge":
			return TileInf.BRIDGE
		"park":
			return TileInf.PARK
		"fire_station":
			return TileInf.FIRE_STATION
		"hospital":
			return TileInf.HOSPITAL
		"police_station":
			return TileInf.POLICE_STATION
		"library":
			return TileInf.LIBRARY
		"museum":
			return TileInf.MUSEUM
		"school":
			return TileInf.SCHOOL
		"house":
			return TileInf.HOUSE
		"building":
			return TileInf.BUILDING
		"beach_rocks":
			return TileInf.BEACH_ROCKS
		"beach_grass":
			return TileInf.BEACH_GRASS
		"utilities_plant":
			return TileInf.UTILITIES_PLANT
		"sewage_facility":
			return TileInf.SEWAGE_FACILITY
		"waste_treatment":
			return TileInf.WASTE_TREATMENT
		"child":
			return TileInf.CHILD


func convert_inf_to_string():
	match inf:
		TileInf.NONE:
			return "none"
		TileInf.ROAD:
			return "road"
		TileInf.BRIDGE:
			return "bridge"
		TileInf.PARK:
			return "park"
		TileInf.FIRE_STATION:
			return "fire_station"
		TileInf.HOSPITAL:
			return "hospital"
		TileInf.POLICE_STATION:
			return "police_station"
		TileInf.LIBRARY:
			return "library"
		TileInf.MUSEUM:
			return "museum"
		TileInf.SCHOOL:
			return "school"
		TileInf.HOUSE:
			return "house"
		TileInf.BUILDING:
			return "building"
		TileInf.BEACH_ROCKS:
			return "beach_rocks"
		TileInf.BEACH_GRASS:
			return "beach_grass"
		TileInf.UTILITIES_PLANT:
			return "utilities_plant"
		TileInf.SEWAGE_FACILITY:
			return "sewage_facility"
		TileInf.WASTE_TREATMENT:
			return "waste_treatment"
		TileInf.CHILD:
			return "child"


func convert_string_to_sensor(sensor):
	match sensor:
		"none":
			return TileSensor.NONE
		"tide":
			return TileSensor.TIDE
		"rain":
			return TileSensor.RAIN
		"wind":
			return TileSensor.WIND


func convert_string_to_tile_status(status):
	match status:
		"none":
			return TileStatus.NONE
		"light_damage":
			return TileStatus.LIGHT_DAMAGE
		"medium_damage":
			return TileStatus.MEDIUM_DAMAGE
		"heavy_damage":
			return TileStatus.HEAVY_DAMAGE


func convert_zone_to_string():
	match zone:
		TileZone.NONE:
			return "none"
		TileZone.SINGLE_FAMILY:
			return "single_family"
		TileZone.MULTI_FAMILY:
			return "multi_family"
		TileZone.COMMERCIAL:
			return "commercial"
		TileZone.PUBLIC_WORKS:
			return "public_works"


func convert_base_to_string():
	match base:
		TileBase.DIRT:
			return "dirt"
		TileBase.SAND:
			return "sand"
		TileBase.OCEAN:
			return "ocean"
		TileBase.ROCK:
			return "rock"


func convert_sensor_to_string():
	match sensor:
		TileSensor.NONE:
			return "none"
		TileSensor.TIDE:
			return "tide"
		TileSensor.RAIN:
			return "rain"
		TileSensor.WIND:
			return "wind"


func convert_tile_status_to_string():
	match self.get_status():
		TileStatus.NONE:
			return "none"
		TileStatus.LIGHT_DAMAGE:
			return "light_damage"
		TileStatus.MEDIUM_DAMAGE:
			return "medium_damage"
		TileStatus.HEAVY_DAMAGE:
			return "heavy_damage"


func get_save_tile_data():
	var data_copy = data.duplicate()
	data_copy[4] = convert_tile_status_to_string()

	var tileData = {
		"i": i,
		"j": j,
		"baseHeight": baseHeight,
		"waterHeight": waterHeight,
		"bridgeHeight": bridgeHeight,
		"base": convert_base_to_string(),
		"zone": convert_zone_to_string(),
		"inf": convert_inf_to_string(),
		"data": data_copy,
		"utilities": utilities,
		"children": children,
		"parent": parent,
		"tileDamage": tileDamage,
		"erosion": erosion,
		"landValue": landValue,
		"profitRate": profitRate,
		"happiness": happiness,
		"changeInWaterHeight": changeInWaterHeight,
		"connections": connections,
		"sensor": convert_sensor_to_string(),
		"sensor_active": sensor_active,
		"desirability": desirability,    
		"is_close_water": is_close_water,
		"is_far_water": is_far_water,
		"bridge_connected_to_dirt": bridge_connected_to_dirt,
		"tile_base_dirt": tile_base_dirt,
		"tile_base_rock": tile_base_rock,
		"tile_base_sand": tile_base_sand,
		"residential_neighbors": residential_neighbors,
		"commercial_neighbors": commercial_neighbors,
		"industrial_neighbors": industrial_neighbors,
		"public_works_neighbors": PUBLIC_WORKS_NEIGHBORS,
		"public_works_dictionary": public_works_dictionary,
		"prop_tax_weight": prop_tax_weight,
		"is_sales_tax_heavy": is_sales_tax_heavy,
		"is_sales_tax_neutral": is_sales_tax_neutral,
		"is_sales_tax_light": is_sales_tax_light,
		"is_prop_tax_heavy": is_prop_tax_heavy,
		"is_prop_tax_neutral": is_prop_tax_neutral,
		"is_prop_tax_light": is_prop_tax_light,
		"is_income_tax_heavy": is_income_tax_heavy,
		"is_income_tax_neutral": is_income_tax_neutral,
		"is_income_tax_light": is_income_tax_light,
		"is_neg_profit": is_neg_profit,
		"wealth_weight": wealth_weight,
		"tile_dmg_weight": tile_dmg_weight
	}
	
	return tileData

func paste_tile(tile):
	baseHeight = tile.baseHeight
	waterHeight = tile.waterHeight
	base = tile.base
	zone = tile.zone
	inf = tile.inf
	data = tile.data
	tileDamage = tile.tileDamage
	landValue = tile.landValue
	profitRate = tile.profitRate

func check_if_valid_placement(inf_to_be, height, width):
	if inf_to_be == TileInf.WAVE_BREAKER:
		if !get_base() == TileBase.SAND || baseHeight > 5:
			return false
	elif !((get_base() == TileBase.DIRT || get_base() == TileBase.ROCK) && inf != inf_to_be):
		return false
	
	for a in range(0, height):
		for b in range(0, width):
			if (i - a >= 0 and j - b >= 0):
				var currTile = Global.tileMap[i - a][j - b]
				if currTile.inf != TileInf.NONE or currTile.zone != TileZone.NONE:
					return false
				elif currTile.baseHeight != baseHeight:
					return false
			else:
				#If I or J fall out of range, it is invalid
				return false
	return true

func set_tile_inf(infType, zoneType, height, width):
	clear_tile()
	inf = infType
	zone = zoneType
	for a in range(0, height):
		for b in range(0, width):
			if a == 0 and b == 0:
				continue
			#No need to check if valid, already did that
			var currTile = Global.tileMap[i - a][j - b]
			currTile.inf = TileInf.CHILD
			currTile.zone = zoneType
			currTile.parent = [i, j]
			children.append([i - a, j - b])
	City.connectUtilities()

func clear_tile():
	#remove all buildings 
	while (data[0] > 0):
		remove_building()
	
	#inform the Announcer that we have removed a zone
	if is_commercial():
			var currEvent = Event.new("Removed Tile", "Removed Commercial Area", 1)
			Announcer.notify(currEvent)
			currEvent.queue_free()
	elif is_residential():
		tileDamage -= data[0] * Econ.REMOVE_BUILDING_DAMAGE
		var currEvent = Event.new("Removed Tile", "Removed Residential Area", 1)
		Announcer.notify(currEvent)
		currEvent.queue_free()
	else:
		tileDamage -= data[0] * Econ.REMOVE_BUILDING_DAMAGE
	if tileDamage < 0:
		tileDamage = 0
	if inf == TileInf.UTILITIES_PLANT:
		var currEvent = Event.new("Removed Tile", "Removed Power Plant", 1)
		Announcer.notify(currEvent)
		currEvent.queue_free()
	elif inf == TileInf.ROAD:
		var currEvent = Event.new("Removed Tile", "Removed Road", 1)
		Announcer.notify(currEvent)
		currEvent.queue_free()
	elif inf == TileInf.PARK:
		var currEvent = Event.new("Removed Tile", "Removed Park", 1)
		Announcer.notify(currEvent)
		currEvent.queue_free()
	#reset zones
	zone = TileZone.NONE
	
	#reconnect utility if road or utility plant is cleared
	if (inf == TileInf.UTILITIES_PLANT || inf == TileInf.ROAD || inf == TileInf.BRIDGE):
		inf = TileInf.NONE
		City.connectUtilities()
		
	sensor = TileSensor.NONE	
	#reset tile to base
	inf = TileInf.NONE
	data = [0, 0, 0, 0, 0]
	tileDamage = 0
	connections = [0, 0, 0, 0]
	
	for child in children:
		#Only works under the assumption that two tiles will not be both children of each other
		#Otherwise we will have an infinite loop
		Global.tileMap[child[0]][child[1]].clear_tile()
	children.clear()
	parent = [-1, -1]
	
func raise_tile():
	baseHeight += 1
	if baseHeight > Global.MAX_HEIGHT:
		baseHeight = Global.MAX_HEIGHT

func lower_tile():
	baseHeight -= 1
	if baseHeight < 0:
		baseHeight = 0

func set_height_zero():
	baseHeight = 0

func raise_water():
	waterHeight += 3
	changeInWaterHeight = 3
	if (waterHeight + baseHeight) > Global.MAX_HEIGHT:
		waterHeight = Global.MAX_HEIGHT - baseHeight

func lower_water():
	waterHeight -= 1
	changeInWaterHeight = -1
	if waterHeight < 0:
		waterHeight = 0

func can_zone():
	return base == TileBase.DIRT || base == TileBase.ROCK

func get_base():
	return base

func get_status():
	return data[4]

func set_base(b):
	base = b

func get_base_height():
	return baseHeight

func get_water_height():
	return waterHeight
	
func get_wear_and_tear():
	return wearAndTear

func get_number_of_buildings():
	if inf == TileInf.BUILDING:
		return data[0]
	else:
		return 0

func is_zoned():
	return zone != TileZone.NONE

func is_light_zoned():
	return zone == TileZone.SINGLE_FAMILY || zone == TileZone.COMMERCIAL

func is_heavy_zoned():
	return zone == TileZone.MULTI_FAMILY || zone == TileZone.COMMERCIAL

func set_base_height(h):
	if 0 <= h && h <= Global.MAX_HEIGHT:
		baseHeight = h

func set_water_height(w):
	if 0 <= w && w <= Global.MAX_HEIGHT:
		waterHeight = w

func can_build():
	if zone == TileZone.SINGLE_FAMILY || zone == TileZone.MULTI_FAMILY:
		return true
	elif zone == TileZone.COMMERCIAL:
		return true
	return false

func is_ocean():
	return base == TileBase.OCEAN

# Data is a generic array that stores values based on the type of infrastructure present
# For housing, the data stores and array of the following values:
# - [0] Number of houses present
# - [1] Number of houses maximum
# - [2] People living there
# - [3] Maximum people
# - [4] Status of tile (0: unoccupied, 1: Occupied, 2: Damaged, 3: Severe Damage, 4: Abandonded)

func remove_water():
	waterHeight = 0
	changeInWaterHeight = 0

func set_damage(n):
	#tiles without buildings/zoning or roads/bridges should not be damaged
	if !is_zoned() && !TileInf.ROAD && !TileInf.BRIDGE:
		return
	if n == TileStatus.LIGHT_DAMAGE:
		tileDamage += .25
	elif n == TileStatus.MEDIUM_DAMAGE:
		tileDamage += .5
	elif n == TileStatus.HEAVY_DAMAGE:
		tileDamage += .75
		
	if tileDamage < .5:
		data[4] = TileStatus.LIGHT_DAMAGE
	elif tileDamage >=.5 && tileDamage <= .75:
		data[4] = TileStatus.MEDIUM_DAMAGE
	elif tileDamage > .75:
		data[4] = TileStatus.HEAVY_DAMAGE
	if tileDamage >= 1:
		tileDamage = 1
		if is_zoned():
			#the tile is completely destroyed at this point
			#should remove all buildings and all population?
			while data[0] > 0:
				remove_building()
		elif inf == TileInf.ROAD || inf == TileInf.BRIDGE:
			#if damage is absolute, clear road.
			clear_tile()
		

func has_utilities():
	return utilities

func get_zone():
	return zone

func has_building():
	return inf == TileInf.BUILDING

func set_zone(type):
	zone = type
	match zone: 
		#single family and commercial have 4 houses/buildings max
		TileZone.SINGLE_FAMILY, TileZone.COMMERCIAL:
			data = [0, 4, 0, 0, 0]
		#multi family has 18 houses max
		TileZone.MULTI_FAMILY:
			data = [0, 4, 0, 0, 0]
		_:
			data = [0, 0, 0, 0, 0]

func add_building():
	#if there is something that isn't a building already on this tile, do nothing
	if inf != TileInf.NONE && inf != TileInf.BUILDING:
		return		
	inf = TileInf.BUILDING
	if data[0] < data[1]:
#		data[0] += 1
#		data[3] += 4
		match zone: 
			#single family homes hold 1, so 4 houses for 4 people
			TileZone.SINGLE_FAMILY:
				data[0] += 1
				data[3] += 1
			#multi family holds 4 and so does commercial
			#represents many businesses and many apartments in one zone, 
			#while single family is much less dense
			TileZone.COMMERCIAL:
				data[0] += 1
				data[3] += 4
			#no other zone type should be affected
			TileZone.MULTI_FAMILY:
				data[0] += 1
				data[3] += 16
			_:
				pass

func remove_building():
	#if there is not a building, nothing to remove
	if inf != TileInf.BUILDING:
		return		
	# if there is only one building
	if data[0] <= 1:
		data[0] = 0
		data[1] = 4
		remove_people(data[2])
		data[3] = 0
		inf = TileInf.NONE
		
	#if there is more than 1 building
	else:
#		data[0] -= 1
#		data[3] -= 4
		match zone:
			TileZone.SINGLE_FAMILY:
				data[0] -= 1
				data[3] -= 1
			TileZone.MULTI_FAMILY:
				data[0] -= 1
				data[3] -= 4
			_:
				data[0] -= 1
				data[3] -= 4
		if data[2] > data[3]:
#			data[2] = data[3]
			var diff = data[2] - data[3]
			remove_people(diff)
			
	#clamp tile damage to 0
	if tileDamage < 0:
		tileDamage = 0

func add_people(n):	
	var before = data[2]
	data[2] += n
	if data[2] > data[3]:
		data[2] = data[3]
	var diff = data[2] - before
	if (is_residential()):
		UpdatePopulation.change_residents(diff)
	elif (is_commercial()):
		UpdatePopulation.change_workers(diff)
	return diff

func remove_people(n):		
	var before = data[2]
	data[2] -= n
	if data[2] <= 0:
		data[2] = 0
		#data[4] = 0
	var diff = data[2] - before
	if (is_residential()):
		UpdatePopulation.change_residents(diff)
	elif (is_commercial()):
		UpdatePopulation.change_workers(diff)
	return diff

func clear_house():
	if zone != TileZone.RESIDENTIAL:
		return
	
	inf = TileInf.NONE
	while (data[0] > 0):
		remove_building()
	data = [0, 0, 0, 0, 0]

func get_sensor():
	return sensor
	
func clear_sensor():
	sensor = TileSensor.NONE

func get_data():
	return data

func get_public_works_value():
	var value = 0
	if zone == TileZone.SINGLE_FAMILY:
		pass
	#This was the calculation I came up with for diminishing returns. Each of the same neighbor provides less value
	var parkValue = PARK_NEIGHBORS
	for i in range(public_works_dictionary['parks']):
		value += parkValue
		parkValue -= 0.025
		if parkValue <= 0:
			break
	var libraryValue = LIBRARY_NEIGHBORS
	for i in range(public_works_dictionary['libraries']):
		value += libraryValue
		libraryValue -= 0.025
		if libraryValue <= 0:
			break
	var museumValue = MUSEUM_NEIGHBORS
	for i in range(public_works_dictionary['museums']):
		value += museumValue
		museumValue -= 0.025
		if museumValue <= 0:
			break
	var schoolValue = SCHOOL_NEIGHBORS
	for i in range(public_works_dictionary['school']):
		value += schoolValue
		schoolValue -= 0.025
		if schoolValue <= 0:
			break
	if public_works_dictionary['fire_stations'] > 0:
		value += FIRE_STATION_NEIGHBORS
	if public_works_dictionary['hospitals'] > 0:
		value += HOSPITAL_NEIGHBORS
	if public_works_dictionary['police_stations'] > 0:
		value += POLICE_STATION_NEIGHBORS
	return value

func _ready():
	pass

func is_residential():
	return zone == TileZone.SINGLE_FAMILY || zone == TileZone.MULTI_FAMILY
	
func is_commercial():
	return zone == TileZone.COMMERCIAL

func distance_to_water():
#	 set distance to the maximum possible value any tile could be from water
	var distance = 999999
#	checking a 6 tile radius circle around the current tile
	for x in range(i-6, i+7):
		for y in range(j-6, j+7):
			if is_valid_tile(x, y):
				if Global.tileMap[x][y].is_ocean():
	#				this is the distance from our current tile to the base tile
					var x2x1 = x - i
					var y2y1 = y - j
					var temp_distance = sqrt(x2x1*x2x1 - y2y1*y2y1)
					if temp_distance < distance:
						 distance = temp_distance
	
#	if the distance value has been changed, return it
	if distance != 999999:
		return distance
	else:
		 return null

#copied from presence_of_water.gd for use in above function as a helper
func is_valid_tile(i, j) -> bool:
	if i < 0 || Global.mapHeight <= i:
		return false
	if j < 0 || Global.mapWidth <= j:
		return false
	return true
