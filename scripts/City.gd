extends Node

var numParks = 0
var numUtilityPlants = 0
var numRoads = 0
var numBridges = 0
var numBoardwalks = 0
var numLibraries = 0
var numMuseums = 0
var numSchools = 0
var numFireStations = 0
var numHospital = 0
var numPoliceStations = 0
var numSewageFacilities = 0
var numWasteTreatment = 0
var numWaveBreaker = 0
var numResidentialZones = 0
var numCommercialZones = 0
var numSingleFamilyZones = 0
var numMultiFamilyZones = 0

func get_city_data():
	var cityData = {
		"numParks": numParks,
		"numUtilityPlants": numUtilityPlants,
		"numRoads": numRoads,
		"numBridges": numBridges,
		"numBoardwalks": numBoardwalks,
		"numLibraries": numLibraries,
		"numMuseums": numMuseums,
		"numSchools": numSchools,
		"numFireStations": numFireStations,
		"numHospital": numHospital,
		"numPoliceStations": numPoliceStations,
		"numSewageFacilities": numSewageFacilities,
		"numWasteTreatment": numWasteTreatment,
		"numResidentialZones": numResidentialZones,
		"numCommercialZones": numCommercialZones,
		"numSingleFamilyZones": numSingleFamilyZones,
		"numMultiFamilyZones": numMultiFamilyZones
	}

	return cityData;

func load_city_data(data):
	if not data.empty():
		for key in data:
			self.set(key, data[key])

# Delete the last row and column of the map
func reduce_map():
	if Global.mapHeight <= Global.MIN_MAP_SIZE || Global.mapWidth <= Global.MIN_MAP_SIZE:
		return
	
	Global.mapHeight -= 1
	
	for j in Global.mapWidth:
		$VectorMap.remove_tile(Global.mapHeight, j)
	
	Global.mapWidth -= 1
	
	for i in Global.mapHeight:
		$VectorMap.remove_tile(i, Global.mapWidth)
	
	Global.tileMap.pop_back()
	
	for i in Global.tileMap.size():
		Global.tileMap[i].pop_back()
	
	get_node("HUD/BottomBar/HoverText").text = "Map size reduced to (%s x %s)" % [Global.mapWidth, Global.mapHeight]
	
# Add a new row and column of empty tiles
func extend_map():
	if Global.mapHeight >= Global.MAX_MAP_SIZE || Global.mapWidth >= Global.MAX_MAP_SIZE:
		return
	
	var new_row = []
	new_row.resize(Global.mapWidth)
	Global.tileMap.append(new_row)

	for j in Global.mapWidth:
		Global.tileMap[Global.mapHeight][j] = Tile.new({
				"i": Global.mapHeight,
				"j": j,
				"landValue": Econ.TILE_BASE_VALUE
			})
		$VectorMap.add_tile(Global.mapHeight, j)
	
	Global.mapHeight += 1
		
	for i in Global.mapHeight:
		Global.tileMap[i].append(Tile.new({
				"i": i,
				"j": Global.mapWidth,
				"landValue": Econ.TILE_BASE_VALUE
			}))
		$VectorMap.add_tile(i, Global.mapWidth)
	
	Global.mapWidth += 1

	get_node("HUD/BottomBar/HoverText").text = "Map size extended to (%s x %s)" % [Global.mapWidth, Global.mapHeight]
	

# Starting from each utility plant, trace utility distribution and utility tiles if they are connected
func connectUtilities():
	var utilityPlants = []
	
	# De-utility every tile on the map, find location of any utility plants
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			Global.tileMap[i][j].utilities = false
			#Global.tileMap[i][j].cube.update()
			if Global.tileMap[i][j].inf == Tile.TileInf.UTILITIES_PLANT:
				utilityPlants.append(Global.tileMap[i][j])
	
	# For the announcer to keep track of the number of specific tiles powered
	var roadsPowered = 0
	var commsPowered = 0
	var resPowered = 0

	for plant in utilityPlants:
		plant.utilities = true

		var queue = []
		var neighbors = [[plant.i-1, plant.j], [plant.i+1, plant.j], [plant.i, plant.j-1], [plant.i, plant.j+1]]
		
		# If an adjacent tile is a road, add it to the queue
		for n in neighbors:
			if roadConnected(plant, n, Global.MAX_CONNECTION_HEIGHT):
				queue.append(Global.tileMap[n[0]][n[1]])
		
		# Add each connected road tile that hasn't yet been checked to the queue, utility adjacent tiles
		while !queue.empty():
			var road = queue.pop_front()
			
			# If road is not powered, it hasn't yet been checked
			if !road.utilities:
				roadsPowered += 1
				road.utilities = true
			
				# Check neighbors: if it's a connected road, add it to the queue; otherwise, utility tile
				neighbors = [[road.i-1, road.j], [road.i+1, road.j], [road.i, road.j-1], [road.i, road.j+1]]

				for n in neighbors:
					if is_tile_inbounds(n[0], n[1]):
						var currTile = Global.tileMap[n[0]][n[1]]
						if currTile.inf == Tile.TileInf.ROAD || currTile.inf == Tile.TileInf.BRIDGE || currTile.inf == Tile.TileInf.BOARDWALK:
							if roadConnected(road, n, Global.MAX_CONNECTION_HEIGHT):
								if currTile.utilities == false:
									queue.append(currTile)
						elif currTile.inf == Tile.TileInf.CHILD:
							#If we connect with a child tile
							if currTile.utilities == false:
								var parentTile = Global.tileMap[currTile.parent[0]][currTile.parent[1]]
								parentTile.utilities = true
								for child in parentTile.children:
									Global.tileMap[child[0]][child[1]].utilities = true
						elif currTile.children.size() > 0:
							#If we connect with a parent tile
							if currTile.utilities == false:
								currTile.utilities = true
								for child in currTile.children:
									Global.tileMap[child[0]][child[1]].utilities = true
						else:
							if currTile.is_commercial():
								commsPowered += 1
							elif currTile.is_residential():
								resPowered += 1
							currTile.utilities = true
							#Global.tileMap[n[0]][n[1]].cube.update()
	var event1 = Event.new("Tiles Powered", "Number of powered roads", roadsPowered)
	Announcer.notify(event1)
	event1.queue_free()
	var event2 = Event.new("Tiles Powered", "Number of powered commercial areas", commsPowered)
	Announcer.notify(event2)
	event2.queue_free()
	var event3 = Event.new("Tiles Powered", "Number of powered residential areas", resPowered)
	Announcer.notify(event3)
	event3.queue_free()

# Check tile for neighboring road connections, and create connections from any connecting roads to tile
func connectRoads(tile):
	var queue = [tile]
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
	var maxHeightDiff = Global.MAX_CONNECTION_HEIGHT

	for n in neighbors:
		if roadConnected(tile, n, maxHeightDiff):
			queue.append(Global.tileMap[n[0]][n[1]])

	while !queue.empty():
		var road = queue.pop_front()
		road.connections = 	[0, 0, 0, 0]

		if roadConnected(road, [road.i-1, road.j], maxHeightDiff):
			road.connections[0] = 1
		if roadConnected(road, [road.i, road.j-1], maxHeightDiff):
			road.connections[1] = 1
		if roadConnected(road, [road.i+1, road.j], maxHeightDiff):
			road.connections[2] = 1
		if roadConnected(road, [road.i, road.j+1], maxHeightDiff):
			road.connections[3] = 1

func disconnectBridges(tile):
	tile.bridge_connected_to_dirt = false
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
	var checked = []
	for n in neighbors:
		checked.append(n)
		if is_tile_inbounds(n[0], n[1]):
			if Global.tileMap[n[0]][n[1]].inf == Tile.TileInf.BRIDGE:
				var currTile = Global.tileMap[n[0]][n[1]]
				currTile.bridge_connected_to_dirt = false
				if not [currTile.i-1, currTile.j] in checked:
					neighbors.append([currTile.i-1, currTile.j])
				if not [currTile.i+1, currTile.j] in checked:
					neighbors.append([currTile.i+1, currTile.j])
				if not [currTile.i, currTile.j-1] in checked:
					neighbors.append([currTile.i, currTile.j-1])
				if not [currTile.i, currTile.j+1] in checked:
					neighbors.append([currTile.i, currTile.j+1])
	

func roadConnected(tile, n, diff):
	if !is_tile_inbounds(n[0], n[1]):
		return false
	if Global.tileMap[n[0]][n[1]].inf != Tile.TileInf.ROAD && Global.tileMap[n[0]][n[1]].inf != Tile.TileInf.BRIDGE && Global.tileMap[n[0]][n[1]].inf != Tile.TileInf.BOARDWALK:
		return false
	if abs(tile.get_base_height() - Global.tileMap[n[0]][n[1]].get_base_height()) > diff:
		return false
	
	return true

func is_tile_inbounds(i, j):
	if i < 0 || Global.mapHeight <= i:
		return false
	
	if j < 0 || Global.mapWidth <= j:
		return false
	
	return true

func updateOceanHeight(dir):	
	# 2D array to keep track of which map tiles have been checked
	var visited = []
	for x in range(Global.mapWidth):
		visited.append([])
		for _y in range(Global.mapHeight):
			visited[x].append(0)
			
	# Only tiles that have changes to water values are placed in queue
	var queue = []
	
	# Update all ocean tiles, adjust height, then add to queue
	for i in Global.mapWidth:
		for j in Global.mapHeight:
			if Global.tileMap[i][j].is_ocean():
				Global.tileMap[i][j].baseHeight = Global.oceanHeight
				Global.tileMap[i][j].waterHeight = 0
				#Global.tileMap[i][j].cube.update()
				visited[i][j] = 1
				queue.append(Global.tileMap[i][j])

	# For each tile in queue, adjust water height, then check if neighbors should be added to queue
	while !queue.empty():
		var tile = queue.pop_front()

		# Adjust water height to match ocean height
		if !tile.is_ocean():
			var prevHeight = tile.waterHeight;
			tile.waterHeight = Global.oceanHeight - tile.baseHeight
			tile.changeInWaterHeight = tile.waterHeight - prevHeight;
			#Global.tileMap[tile.i][tile.j].cube.update()

		# Check each orthogonal neighbor to determine if it will flood
		var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
		for n in neighbors:
			if is_tile_inbounds(n[0], n[1]) && visited[n[0]][n[1]] == 0:
				visited[n[0]][n[1]] = 1
				
				# Rising ocean level
				if dir > 0 && Global.tileMap[n[0]][n[1]].baseHeight < Global.oceanHeight:
					queue.append(Global.tileMap[n[0]][n[1]])

				# Falling ocean level
				if dir < 1 && Global.tileMap[n[0]][n[1]].baseHeight + Global.tileMap[n[0]][n[1]].waterHeight > Global.oceanHeight:
					if Global.tileMap[n[0]][n[1]].waterHeight >= 1:
						queue.append(Global.tileMap[n[0]][n[1]])

# Changes a tile's height depending on type of click
func adjust_tile_height(tile):	
	if Input.is_action_pressed("left_click"):
		tile.raise_tile()
	elif Input.is_action_pressed("right_click"):
		tile.lower_tile()

func make_tile_water(tile):
	tile.set_height_zero()

# Change water height of tile
func adjust_tile_water(tile):
	if Input.is_action_pressed("left_click"):
		tile.raise_water()
	elif Input.is_action_just_pressed("right_click"):
		tile.lower_water()

func adjust_building_number(tile):
	if Input.is_action_pressed("left_click"):
		tile.add_building()
	elif Input.is_action_pressed("right_click"):
		tile.remove_building()

func adjust_people_number(tile):
	if Input.is_action_pressed("left_click"):
		tile.add_people(1)
	elif Input.is_action_pressed("right_click"):
		tile.remove_people(1)

func calculate_satisfaction():
	var population = 0
	var employees = 0
	var houses = 0
	var apartments = 0
	var stores = 0
	var offices = 0
	var roads = 0
	var parks = 0
	var beaches = 0
	
# When flooding occurs, determine damage to infrastructure and perform tile erosion
# When wear and tear occurs on road tiles, determine damage
func calculate_damage():
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			var tile = Global.tileMap[i][j]
			# Determine damage based on water height to buildings and roads
			if tile.get_water_height() > 0 && tile.changeInWaterHeight > 0:
				if tile.has_building() && tile.is_light_zoned():
					if tile.get_water_height() <= 1:
						tile.set_damage(Tile.TileStatus.LIGHT_DAMAGE)
					elif tile.get_water_height() <= 3:
						tile.set_damage(Tile.TileStatus.MEDIUM_DAMAGE)
					else:
						tile.set_damage(Tile.TileStatus.HEAVY_DAMAGE)
				elif tile.has_building() && tile.is_heavy_zoned():
					if tile.get_water_height() <= 3:
						tile.set_damage(Tile.TileStatus.LIGHT_DAMAGE)
					elif tile.get_water_height() <= 6:
						tile.set_damage(Tile.TileStatus.MEDIUM_DAMAGE)
					else:
						tile.set_damage(Tile.TileStatus.HEAVY_DAMAGE)
				elif tile.inf == Tile.TileInf.ROAD || tile.inf == Tile.TileInf.BRIDGE || tile.inf == Tile.TileInf.BOARDWALK:
					if tile.get_water_height() > 1 && tile.get_water_height() <= 3:
						tile.set_damage(Tile.TileStatus.LIGHT_DAMAGE)
					elif tile.get_water_height() <= 5:
						tile.set_damage(Tile.TileStatus.MEDIUM_DAMAGE)
					else:
						tile.set_damage(Tile.TileStatus.HEAVY_DAMAGE)
				elif tile.get_base() == Tile.TileBase.SAND:
					if tile.get_water_height() >= 5:
						tile.lower_tile()
				#TODO: Decide later if we want to remove the water from flooded tiles automatically
				#tile.remove_water()
				#tile.cube.update()
				tile.changeInWaterHeight = 0
			# For now, only road tiles can get wear and tear damage. If changed further checks should be implemented.
			# Determine damage based on wear and tear to roads
			if tile.get_wear_and_tear() >= 1 && tile.changeInWearAndTear:
				if tile.get_wear_and_tear() <= 3:
					tile.set_damage(Tile.TileStatus.LIGHT_DAMAGE)
				elif tile.get_wear_and_tear() <= 5:
					tile.set_damage(Tile.TileStatus.MEDIUM_DAMAGE)
				else:
					tile.set_damage(Tile.TileStatus.HEAVY_DAMAGE)
				tile.changeInWearAndTear = false

# Update wear and tear for road and bridge tiles. called in updateDate
func calculate_wear_and_tear():
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			var tile = Global.tileMap[i][j]
			
			if tile.inf == tile.TileInf.ROAD || tile.inf == tile.TileInf.BRIDGE || tile.inf == tile.TileInf.BOARDWALK:
				var chanceOfDamage
				if tile.inf == tile.TileInf.BOARDWALK:
					chanceOfDamage = 0.006 #boardwalk has higher chance of damage from being close to sea.
				else:
					chanceOfDamage = 0.005 #all roads/bridges have a minimum 0.5% chance of damage due to natural elements not based on usage
				
				# Check if neighbor tiles are zoned. Based on zoning determine wear and tear probability
				var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
				for n in neighbors:
					if is_tile_inbounds(n[0], n[1]) and Global.tileMap[n[0]][n[1]].is_zoned():
						var currTile = Global.tileMap[n[0]][n[1]]
						if currTile.get_zone() != tile.TileZone.PUBLIC_WORKS:
							chanceOfDamage += pop_based_damage_helper(currTile)
						# for public works zones
						else:
							# police and fire stations depend on how many people work there
							if currTile.inf == tile.TileInf.POLICE_STATION \
							or currTile.inf == tile.TileInf.FIRE_STATION:
								chanceOfDamage += 0.01
							# damage from hospital decreases if more than one hospital
							elif currTile.inf == tile.TileInf.HOSPITAL:
								chanceOfDamage += 0.02 + (0.02 / numHospital)
							# parks, libraries, schools, and museums depend on surrounding population
							else:
								var pwNeighbors = [[currTile.i-1, currTile.j], [currTile.i-1, currTile.j-1], \
								[currTile.i, currTile.j-1], [currTile.i+1, currTile.j-1], [currTile.i+1, currTile.j], \
								[currTile.i+1, currTile.j+1], [currTile.i, currTile.j+1], [currTile.i-1, currTile.j+1]]
								for pw in pwNeighbors:
									if is_tile_inbounds(pw[0], pw[1]) and Global.tileMap[pw[0]][pw[1]].is_zoned() and \
									Global.tileMap[pw[0]][pw[1]].get_zone() != tile.TileZone.PUBLIC_WORKS:
										var pwTile = Global.tileMap[pw[0]][pw[1]]						
										chanceOfDamage += pop_based_damage_helper(pwTile)
				var randomNum = randf()
				#if random number is within chance of damage range, damage has occured.
				if randomNum <= chanceOfDamage:
					#generate another random number to determine extent of damage
					randomNum = randf()
					if randomNum <= 0.50:
						tile.wearAndTear += 1
					elif randomNum <= 0.75:
						tile.wearAndTear += 2
					else:
						tile.wearAndTear += 3
					tile.changeInWearAndTear = true
				
func pop_based_damage_helper(tile):
	var chanceOfDamage = 0
	# damage from commercial or res zones is based on tile population (data[2])
	# data[2] value of 4 is max single family, 72 is max multi family, and 16 is max commerical
	if tile.data[2] >= 4:
		if tile.data[2] <= 16:
			chanceOfDamage += 0.01
		elif tile.data[2] <= 32:
			chanceOfDamage += 0.03
		else:
			chanceOfDamage += 0.05
	return chanceOfDamage
						
func tile_out_of_bounds(cube):
	return cube.i < 0 || Global.mapWidth <= cube.i || cube.j < 0 || Global.mapHeight <= cube.j
	
func _ready():
	pass # Replace with function body.

