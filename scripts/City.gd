extends Node

var numParks = 0
var numUtilityPlants = 0
var numRoads = 0
var numBridges = 0
var numLibraries = 0
var numMuseums = 0
var numSchools = 0
var numFireStations = 0
var numHospital = 0
var numPoliceStations = 0
var numSewageFacilities = 0
var numWasteTreatment = 0
var numResidentialZones = 0
var numCommercialZones = 0
var numSingleFamilyZones = 0
var numMultiFamilyZones = 0

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
		Global.tileMap[Global.mapHeight][j] = Tile.new(Global.mapHeight, j, 0, 0, 0, 0, 0, [0, 0, 0, 0, 0], 0, Econ.TILE_BASE_VALUE, 0)
		$VectorMap.add_tile(Global.mapHeight, j)
	
	Global.mapHeight += 1
		
	for i in Global.mapHeight:
		Global.tileMap[i].append(Tile.new(i, Global.mapWidth, 0, 0, 0, 0, 0, [0, 0, 0, 0, 0], 0, Econ.TILE_BASE_VALUE, 0))
		$VectorMap.add_tile(i, Global.mapWidth)
	
	Global.mapWidth += 1

	get_node("HUD/BottomBar/HoverText").text = "Map size extended to (%s x %s)" % [Global.mapWidth, Global.mapHeight]
	

# Starting from each utility plant, trace utility distribution and utility tiles if they are connected
func connectUtilities():
	var utilityPlants = []
	
	# De-utility every tile on the map, find location of any utility plants
	for i in Global.mapWidth:
		for j in Global.mapHeight:
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
						if Global.tileMap[n[0]][n[1]].inf == Tile.TileInf.ROAD || Global.tileMap[n[0]][n[1]].inf == Tile.TileInf.BRIDGE:
							if roadConnected(road, n, Global.MAX_CONNECTION_HEIGHT):
								if Global.tileMap[n[0]][n[1]].utilities == false:
									queue.append(Global.tileMap[n[0]][n[1]])
						else:
							var currTile = Global.tileMap[n[0]][n[1]]
							if currTile.is_commercial():
								commsPowered += 1
							elif currTile.is_residential():
								resPowered += 1
							currTile.utilities = true
							#Global.tileMap[n[0]][n[1]].cube.update()
	
	Announcer.notify(Event.new("Tiles Powered", "Number of powered roads", roadsPowered))
	Announcer.notify(Event.new("Tiles Powered", "Number of powered commercial areas", commsPowered))
	Announcer.notify(Event.new("Tiles Powered", "Number of powered residential areas", resPowered))

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
	if Global.tileMap[n[0]][n[1]].inf != Tile.TileInf.ROAD && Global.tileMap[n[0]][n[1]].inf != Tile.TileInf.BRIDGE:
		return false
	if abs(tile.get_base_height() - Global.tileMap[n[0]][n[1]].get_base_height()) > diff:
		return false
	
	return true

func is_tile_inbounds(i, j):
	if i < 0 || Global.mapWidth <= i:
		return false
	
	if j < 0 || Global.mapHeight <= j:
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
func calculate_damage():
	for i in Global.mapWidth:
		for j in Global.mapHeight:
			var tile = Global.tileMap[i][j]
			# If buildings present, determine damage based on water height
			if tile.get_water_height() > 0:
				if tile.has_building() && tile.is_light_zoned():
					if tile.get_water_height() <= 1 && tile.changeInWaterHeight > 0:
						tile.set_damage(Tile.TileStatus.LIGHT_DAMAGE)
					elif tile.get_water_height() <= 3 && tile.changeInWaterHeight > 0:
						tile.set_damage(Tile.TileStatus.MEDIUM_DAMAGE)
					elif tile.get_water_height() > 3 && tile.changeInWaterHeight > 0: 
						tile.set_damage(Tile.TileStatus.HEAVY_DAMAGE)
				elif tile.has_building() && tile.is_heavy_zoned():
					if tile.get_water_height() <= 3 && tile.changeInWaterHeight > 0:
						tile.set_damage(Tile.TileStatus.LIGHT_DAMAGE)
					elif tile.get_water_height() <= 6 && tile.changeInWaterHeight > 0:
						tile.set_damage(Tile.TileStatus.MEDIUM_DAMAGE)
					elif tile.get_water_height() > 6 && tile.changeInWaterHeight > 0:
						tile.set_damage(Tile.TileStatus.HEAVY_DAMAGE)
				elif tile.inf == Tile.TileInf.ROAD:
					if tile.get_water_height() >= 5:
						tile.clear_tile()
				elif tile.get_base() == Tile.TileBase.SAND:
					if tile.get_water_height() >= 5:
						tile.lower_tile()
				#TODO: Decide later if we want to remove the water from flooded tiles automatically
				#tile.remove_water()
				#tile.cube.update()
				tile.changeInWaterHeight = 0
		
func tile_out_of_bounds(cube):
	return cube.i < 0 || Global.mapWidth <= cube.i || cube.j < 0 || Global.mapHeight <= cube.j
	
func _ready():
	pass # Replace with function body.

