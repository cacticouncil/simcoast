extends Node

#Constants for determining building, move-ins, and move-outs
#Some of these (such as tile value) should actually be calculated
var BASE_BUILD_CHANCE = 0.01
var BASE_MOVE_CHANCE = 0.01
var BASE_LEAVE_CHANCE = 0.01

var NO_UTILITIES_UNHAPPINESS = 10
var DAMAGE_UNHAPPINESS = 10
var SEVERE_DAMAGE_UNHAPPINESS = 30

var RESIDENTS = 0
var WORKERS = 0
var BASE_EMPLOYMENT_RATE = .95
#above 10% unemployment and people are unhappy 
var UNEMPLOYMENT_LIMIT = .10

var rng = RandomNumberGenerator.new()

# metrics for Economy AI
var growth_rate = 0
var previous_population = 0

#Update buildings and population
func update_population():
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			var currTile = Global.tileMap[i][j]
			
			if currTile.on_beach && Global.beginBeachEvacuation:
				if currTile.data[2] > 0:
					var peopleMovedOut = currTile.pre_evacuation_residents - currTile.data[2]
					var ticksPerPerson = floor(UpdateDate.MONTH_TICKS / currTile.pre_evacuation_residents)
					var expectedPeopleMoveOut = UpdateDate.ticksSinceLastMonthChange / ticksPerPerson
					if expectedPeopleMoveOut > peopleMovedOut:
						currTile.remove_people(1)
			elif currTile.on_beach && Global.stayEvacuated:
				pass
			elif currTile.on_beach && Global.moveBackIn:
				if currTile.pre_evacuation_residents > 0:
					var peopleMovedIn = currTile.data[2]
					var ticksPerPerson = floor(UpdateDate.MONTH_TICKS / currTile.pre_evacuation_residents)
					var expectedPeopleMoveIn = UpdateDate.ticksSinceLastMonthChange / ticksPerPerson
					if expectedPeopleMoveIn > peopleMovedIn:
						currTile.add_people(1)
			else:
				var maxRange = currTile.landValue + currTile.happiness
				var selectTile = BASE_BUILD_CHANCE * (currTile.landValue + currTile.happiness)
				
				# cannot add buldings or people without utility, zoning, or if the tile is damaged
				if currTile.is_zoned() && currTile.has_utilities() && currTile.tileDamage == 0:
					rng.randomize()
					#only add buildings to tiles that already have buildings if a tile is at over 50% capacity 
					if (selectTile > rng.randf_range(0, maxRange) && currTile.data[3] != 0 && currTile.data[2]/currTile.data[3] > .5):
						currTile.add_building()
					#if tile has no buildings, add building if random chance hits
					elif (currTile.data[3] == 0 && selectTile > rng.randf_range(0, maxRange)):
						currTile.add_building()
						
					if (selectTile > rng.randf_range(0, maxRange)):
						if (currTile.is_residential()):
							# Person moves in
							currTile.add_people(1)
						elif (currTile.is_commercial()):
							if RESIDENTS * BASE_EMPLOYMENT_RATE > WORKERS:
								currTile.add_people(1)
		
						
				if currTile.has_building():
	#				code related to people moving out of buildings
					var leaveChance = 0
					var status = currTile.get_status()
					
					if (!currTile.has_utilities()):
						leaveChance += NO_UTILITIES_UNHAPPINESS 
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
						#Can't remove more workers than we have
						diff = min(currTile.data[2], diff)
						currTile.remove_people(diff)
					
	
	get_node("/root/CityMap/HUD/HBoxContainer/Population").text = str(RESIDENTS)
	Announcer.notify(Event.new("Total Population", "Number of Citizens", RESIDENTS))
					
func get_population():
	return RESIDENTS
	
func change_workers(n):
	"""if (n > 0 && (WORKERS + n) >= (RESIDENTS * BASE_EMPLOYMENT_RATE)):
		WORKERS = RESIDENTS
	else:
		WORKERS += n
		if (WORKERS < 0):
			WORKERS = 0"""
	WORKERS += n
		
func change_residents(n):
	RESIDENTS += n
	if (RESIDENTS < 0):
		RESIDENTS = 0
		
func calc_pop_growth():
	#this function gets called once a month in UpdateDate.gd, so growth is calculated monthly
	#formula is (pop at t1 - pop at t0)/(pop at t0) * 100
	var diff = RESIDENTS - previous_population
	if previous_population != 0:
		growth_rate = (diff/previous_population) * 100
	else:
		growth_rate = diff * 100
#	update previous population for next time
	previous_population = RESIDENTS
	
func get_growth():
	return growth_rate
	
func is_unemployment_high() -> bool:
	var rate = float((RESIDENTS - WORKERS) / 100.0)
	if rate > UNEMPLOYMENT_LIMIT:
		return true
	return false

