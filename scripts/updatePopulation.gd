extends Node

#Constants for determining building, move-ins, and move-outs
#Some of these (such as tile value) should actually be calculated
var BASE_BUILD_CHANCE = 0.01
var BASE_MOVE_CHANCE = 0.01
var BASE_LEAVE_CHANCE = 0.01

var NO_POWER_UNHAPPINESS = 10
var DAMAGE_UNHAPPINESS = 10
var SEVERE_DAMAGE_UNHAPPINESS = 30

var RESIDENTS = 0
var WORKERS = 0
var BASE_EMPLOYMENT_RATE = .95

var rng = RandomNumberGenerator.new()

#Update buildings and population
func update_population():
	for i in Global.mapWidth:
		for j in Global.mapHeight:
			var currTile = Global.tileMap[i][j]
			
			var maxRange = currTile.landValue + currTile.happiness
			var selectTile = BASE_BUILD_CHANCE * (currTile.landValue + currTile.happiness)
			
			# cannot add buldings or people without power, zoning, or if the tile is damaged
			if currTile.is_zoned() && currTile.is_powered() && currTile.tileDamage == 0:
				rng.randomize()
				#only add buildings to tiles that already have buildings if a tile is at over 50% capacity 
				if (selectTile > rng.randf_range(0, maxRange) && currTile.data[3] != 0 && currTile.data[2]/currTile.data[3] > .5):
					currTile.add_building()
				#if tile has no buildings, add building if random chance hits
				elif (currTile.data[3] == 0 && selectTile > rng.randf_range(0, maxRange)):
					currTile.add_building()
					
				if (selectTile > rng.randf_range(0, maxRange)):
					if (currTile.is_residential()):
						currTile.add_people(1)
					elif (currTile.is_commercial()):
						if RESIDENTS * BASE_EMPLOYMENT_RATE > WORKERS:
							currTile.add_people(1)
	
					
			if currTile.has_building():
#				code related to people moving out of buildings
				var leaveChance = 0
				var status = currTile.get_status()
				
				if (!currTile.is_powered()):
					leaveChance += NO_POWER_UNHAPPINESS 
				if (status == Tile.TileStatus.LIGHT_DAMAGE || status == Tile.TileStatus.MEDIUM_DAMAGE):
					leaveChance += DAMAGE_UNHAPPINESS
				elif (status == Tile.TileStatus.HEAVY_DAMAGE):
					leaveChance += SEVERE_DAMAGE_UNHAPPINESS
				
				rng.randomize()
				if (selectTile * leaveChance > rng.randf_range(0, maxRange) && RESIDENTS > 0):
					currTile.remove_people(1)
				
				#fixes workers not moving out when residents leave
				if (floor(WORKERS - (RESIDENTS * BASE_EMPLOYMENT_RATE)) > 0 && currTile.is_commercial()):
					var diff = floor(WORKERS - (RESIDENTS * BASE_EMPLOYMENT_RATE))
					currTile.remove_people(diff)
					
	
	get_node("/root/CityMap/HUD/HBoxContainer/Population").text = str(RESIDENTS)
	Announcer.notify(Event.new("Total Population", "Number of Citizens", RESIDENTS))
					
func get_population():
	return RESIDENTS
	
func change_workers(n):
	if (n > 0 && WORKERS + n >= RESIDENTS * BASE_EMPLOYMENT_RATE):
		WORKERS = RESIDENTS
	else:
		WORKERS += n
		if (WORKERS < 0):
			WORKERS = 0
		
func change_residents(n):
	RESIDENTS += n
	if (RESIDENTS < 0):
		RESIDENTS = 0
