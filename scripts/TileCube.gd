# Information for how to draw each tile based on properties
extends Area2D

class_name TileCube

var i = 0
var j = 0
var x = 0
var y = 0

var building_visible = true

var base_cube = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
var water_cube = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
var objects = []
var buildingSprite = null
var listOfBuildings = []

var coll = CollisionPolygon2D.new()

func _ready():
	update_polygons()
	z_index = -10
	self.add_child(coll)

func _draw():
	update_polygons()
	
	var tile = Global.tileMap[i][j]
		
	var baseColor = get_cube_colors()
	var waterColor = Tile.WATER_COLOR
	var buildingColor = get_building_colors()
	
	# Draw the sides of the base of the tile cube
	if tile.get_base_height() > 0:
		draw_polygon(base_cube[1].get_polygon(), PoolColorArray([baseColor[1]]))
		draw_polygon(base_cube[2].get_polygon(), PoolColorArray([baseColor[2]]))

	# If water exists on tile, draw the water cube - otherwise draw the top of the base cube
	if tile.get_water_height() > 0:
		draw_polygon(water_cube[1].get_polygon(), PoolColorArray([waterColor[1]]))
		draw_polygon(water_cube[2].get_polygon(), PoolColorArray([waterColor[2]]))
		draw_polygon(water_cube[0].get_polygon(), PoolColorArray([waterColor[0]]))
		draw_polyline(water_cube[0].get_polygon(), waterColor[3])
	else:
		draw_polygon(base_cube[0].get_polygon(), PoolColorArray([baseColor[0]]))
		draw_polyline(base_cube[0].get_polygon(), baseColor[3])

	# Draw objects (buildings, infrastructure) if present
	if tile.has_building() && building_visible:
		for building in listOfBuildings:
			get_parent().add_child(building)
			
	elif tile.inf == Tile.TileInf.PARK:
		get_parent().add_child(buildingSprite)
			
	elif tile.inf == Tile.TileInf.UTILITIES_PLANT:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.SEWAGE_FACILITY:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.WASTE_TREATMENT:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.LIBRARY:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.MUSEUM:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.SCHOOL:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.FIRE_STATION:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.HOSPITAL:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.POLICE_STATION:
		get_parent().add_child(buildingSprite)
		
	elif tile.inf == Tile.TileInf.BEACH_ROCKS:
		for r in objects:
			draw_polygon(r[1].get_polygon(), PoolColorArray([Tile.BEACH_ROCK_COLOR[1]]))
			draw_polygon(r[2].get_polygon(), PoolColorArray([Tile.BEACH_ROCK_COLOR[2]]))
			draw_polygon(r[0].get_polygon(), PoolColorArray([Tile.BEACH_ROCK_COLOR[0]]))
			
	elif tile.inf == Tile.TileInf.BEACH_GRASS:
		for g in objects:
			draw_polyline(g, Tile.TREE_COLOR[0])
			
	elif tile.inf == Tile.TileInf.ROAD:
		for building in listOfBuildings:
			get_parent().add_child(building)
	
	elif tile.inf == Tile.TileInf.BRIDGE:
		for building in listOfBuildings:
			get_parent().add_child(building)

	elif tile.sensor == Tile.TileSensor.TIDE:
		if tile.sensor_active == true:
			for s in objects:
				draw_circle(s,3,Color("D2042D"))
		else:
			for s in objects:
				draw_circle(s,3,Color("808080"))
	elif tile.sensor == Tile.TileSensor.RAIN:
		if tile.sensor_active == true:
			for s in objects:
				draw_circle(s,3,Color("515ADD"))
		else:
			for s in objects:
				draw_circle(s,3,Color("808080"))

func clear_objects():
	for o in objects:
		for p in o:
			if typeof(p) != TYPE_VECTOR2:
				p.queue_free()
	objects.clear()
	buildingSprite = null

func update_polygons():
	var tile = Global.tileMap[i][j]
	var h = tile.get_base_height()
	var w = tile.get_water_height()
	
	update_cube(base_cube, x, y, Global.TILE_WIDTH, Global.TILE_HEIGHT, h, 0, 0)
	update_cube(water_cube, x, y, Global.TILE_WIDTH, Global.TILE_HEIGHT, h + w, h, 0)
	
	if buildingSprite != null:
		get_parent().remove_child(buildingSprite)
	buildingSprite = null
	
	if listOfBuildings.size() > 0:
		for building in listOfBuildings:
			get_parent().remove_child(building)
	listOfBuildings.clear()
	
	# Create simple trees so landscape not so boring
	if tile.inf == Tile.TileInf.PARK:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/Park.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
	
	# Create some one pixel high blades of grass
	elif tile.inf == Tile.TileInf.BEACH_GRASS:
		clear_objects()
		
		if w == 0:
			var grass_x = 0
			var grass_y = 0
			
			for g in 5:
				match g:
					0:
						grass_x = x
						grass_y = y - h + (Global.TILE_HEIGHT / 2.0) / 2.0
					1:
						grass_x = x
						grass_y = y - h + ((Global.TILE_HEIGHT / 2.0) / 2.0 + (Global.TILE_HEIGHT / 2.0))
					2:
						grass_x = x - ((Global.TILE_WIDTH / 2.0) / 2.0)
						grass_y = y - h + (Global.TILE_HEIGHT / 2.0)
					3:
						grass_x = x + ((Global.TILE_WIDTH / 2.0) / 2.0)
						grass_y = y - h + (Global.TILE_HEIGHT / 2.0)
				
					4:
						grass_x = x
						grass_y = y - h + (Global.TILE_HEIGHT / 2.0)
			
				objects.append(PoolVector2Array([
					Vector2(grass_x, grass_y), Vector2(grass_x - 2, grass_y - 2),
					Vector2(grass_x, grass_y), Vector2(grass_x, grass_y - 2),
					Vector2(grass_x, grass_y), Vector2(grass_x + 2, grass_y - 2)
				]))

	elif tile.inf == Tile.TileInf.UTILITIES_PLANT:	
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/UtilityPlant.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
				
	elif tile.inf == Tile.TileInf.SEWAGE_FACILITY:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/SewageFacility.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
	
	elif tile.inf == Tile.TileInf.WASTE_TREATMENT:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/WasteTreatment.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
	
	elif tile.inf == Tile.TileInf.LIBRARY:
		"""
		clear_objects()
		var building_width = Global.TILE_WIDTH - 10
		var building_depth = building_width / 2.0
		var building_height = 15
		
		if w > building_height:
			building_visible = false
		else:
			building_visible = true
		
		var b = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
		
		var building_x = x
		var building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - (building_depth / 2.0))
		
		update_cube(b, building_x, building_y, building_width, building_depth, building_height, w, 0)
		objects.append(b)
		I wanted to leave an example one of how the boxes are done
		"""
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/Library.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
		
	elif tile.inf == Tile.TileInf.MUSEUM:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/Museum.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
	
	elif tile.inf == Tile.TileInf.SCHOOL:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/School.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)

	elif tile.inf == Tile.TileInf.FIRE_STATION:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/Firehouse.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
	
	elif tile.inf == Tile.TileInf.HOSPITAL:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/Hospital.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)
		
	elif tile.inf == Tile.TileInf.POLICE_STATION:
		clear_objects()
		var image = load("res://assets/building_assets/2d Assets/PoliceStation.png")
		buildingSprite = Sprite.new()
		buildingSprite.texture = image
		buildingSprite.position = Vector2(x, y - h)

	# Draws roads depending on data values, which indicate which neighbords tile is connected to
	elif tile.inf == Tile.TileInf.ROAD:
		clear_objects()
		var image
		var currBuilding
		
		if w == 0:
			if tile.connections[0]:
				image = load("res://assets/building_assets/2d Assets/RoadNWConnected.png")
			else:
				image = load("res://assets/building_assets/2d Assets/RoadNW.png")
			
			currBuilding = Sprite.new()
			currBuilding.texture = image
			currBuilding.position = Vector2(x, y - h)
			listOfBuildings.append(currBuilding)
			
			if tile.connections[1]:
				image = load("res://assets/building_assets/2d Assets/RoadNEConnected.png")
			else:
				image = load("res://assets/building_assets/2d Assets/RoadNE.png")
			
			currBuilding = Sprite.new()
			currBuilding.texture = image
			currBuilding.position = Vector2(x, y - h)
			listOfBuildings.append(currBuilding)
			
			if tile.connections[2]:
				image = load("res://assets/building_assets/2d Assets/RoadSEConnected.png")
			else:
				image = load("res://assets/building_assets/2d Assets/RoadSE.png")
			
			currBuilding = Sprite.new()
			currBuilding.texture = image
			currBuilding.position = Vector2(x, y - h)
			listOfBuildings.append(currBuilding)
			
			if tile.connections[3]:
				image = load("res://assets/building_assets/2d Assets/RoadSWConnected.png")
			else:
				image = load("res://assets/building_assets/2d Assets/RoadSW.png")
			
			currBuilding = Sprite.new()
			currBuilding.texture = image
			currBuilding.position = Vector2(x, y - h)
			listOfBuildings.append(currBuilding)
		
		
	elif tile.inf == Tile.TileInf.BRIDGE:
		clear_objects()
		var image
		var currBuilding
		#var tileHeight = Global.TILE_HEIGHT
		var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
		var numNeighbors = 0
		h = 0
		for n in neighbors:
			if is_valid_tile(n[0], n[1]):
				var neighbor = Global.tileMap[n[0]][n[1]]
				if neighbor.get_base() == Tile.TileBase.DIRT:
					h += neighbor.baseHeight
					numNeighbors += 1
		if numNeighbors > 0:
			h = h / numNeighbors
			tile.bridgeHeight = h
			tile.bridge_connected_to_dirt = true
		else:
			#We have no dirt tiles, we should match bridge heights around us
			for n in neighbors:
				if is_valid_tile(n[0], n[1]):
					var neighbor = Global.tileMap[n[0]][n[1]]
					if neighbor.inf == Tile.TileInf.BRIDGE && neighbor.bridge_connected_to_dirt:
						h += neighbor.bridgeHeight
						numNeighbors += 1
			if numNeighbors > 0:
				h = h / numNeighbors
				tile.bridgeHeight = h
				tile.bridge_connected_to_dirt = true
			else:
				h = Global.oceanHeight
				tile.bridgeHeight = h
		var building_width = Global.TILE_WIDTH
		var building_depth = building_width / 2.0
		var building_height = 0
		var cube_x = x
		var cube_y = y - h + ((Global.TILE_HEIGHT / 2.0) - (building_depth / 2.0))
		
		if tile.connections[0]:
			image = load("res://assets/building_assets/2d Assets/RoadNWConnected.png")
		else:
			image = load("res://assets/building_assets/2d Assets/RoadNW.png")
		
		currBuilding = Sprite.new()
		currBuilding.texture = image
		currBuilding.position = Vector2(x, y - h)
		listOfBuildings.append(currBuilding)
		
		if tile.connections[1]:
			image = load("res://assets/building_assets/2d Assets/RoadNEConnected.png")
		else:
			image = load("res://assets/building_assets/2d Assets/RoadNE.png")
		
		currBuilding = Sprite.new()
		currBuilding.texture = image
		currBuilding.position = Vector2(x, y - h)
		listOfBuildings.append(currBuilding)
		
		if tile.connections[2]:
			image = load("res://assets/building_assets/2d Assets/RoadSEConnected.png")
		else:
			image = load("res://assets/building_assets/2d Assets/RoadSE.png")
		
		currBuilding = Sprite.new()
		currBuilding.texture = image
		currBuilding.position = Vector2(x, y - h)
		listOfBuildings.append(currBuilding)
		
		if tile.connections[3]:
			image = load("res://assets/building_assets/2d Assets/RoadSWConnected.png")
		else:
			image = load("res://assets/building_assets/2d Assets/RoadSW.png")
		
		currBuilding = Sprite.new()
		currBuilding.texture = image
		currBuilding.position = Vector2(x, y - h)
		listOfBuildings.append(currBuilding)
		
	# Create simple rocks to display beach rocks
	elif tile.inf == Tile.TileInf.BEACH_ROCKS:
		clear_objects()
		var rock_width = Global.TILE_WIDTH / 6.0
		var rock_depth = rock_width / 2.0
		var rock_height = 2
		var rock_x = 0
		var rock_y = 0
		
		if w >= rock_height:
			rock_width = 0
			rock_depth = 0
			rock_height = 0
						
		for z in 5:
			var r = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
				
			match z:
				0:
					rock_x = x
					rock_y = y - h + ((Global.TILE_HEIGHT / 2.0) - rock_depth) / 2.0
				1:
					rock_x = x
					rock_y = y - h + ((Global.TILE_HEIGHT / 2.0) - rock_depth) / 2.0 + (Global.TILE_HEIGHT / 2.0)
				2:
					rock_x = x - (((Global.TILE_WIDTH / 2.0) - rock_width) / 2.0) - (rock_width / 2.0)
					rock_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (rock_depth / 2.0)
				3:
					rock_x = x + (((Global.TILE_WIDTH / 2.0) - rock_width) / 2.0) + (rock_width / 2.0)
					rock_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (rock_depth / 2.0)
			
				4:
					rock_x = x
					rock_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (rock_depth / 2.0)
			
			update_rock(r, rock_x, rock_y, rock_width, rock_depth, rock_height, w)
			objects.append(r)
	# tide sensor marker
	elif tile.sensor == Tile.TileSensor.TIDE || tile.sensor == Tile.TileSensor.RAIN:
		var sens_x = x
		var sens_y = y - h + (Global.TILE_HEIGHT / 2.0) / 2.0
			
		objects.append(Vector2(sens_x, sens_y))
	
	# Generate building polygons depending on density and water height
	elif tile.has_building():
		clear_objects()
		var num_buildings = tile.get_number_of_buildings()
		
		var building_width = 0
		var building_depth = 0
		var building_height = 0
		var building_x = 0
		var building_y = 0
		match tile.get_zone():
			Tile.TileZone.COMMERCIAL:
				building_width = Global.TILE_WIDTH / 4.0
				building_depth = building_width / 2.0
				building_height = 5
				
				if w > building_height:
					building_visible = false
				else:
					building_visible = true
				
				for z in num_buildings:
					var image
					
					match z:
						0:
							building_x = x
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - building_depth) / 2.0
							if tile.data[2] > 0:
								image = load("res://assets/building_assets/2d Assets/Occupied Shop.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")
						1:
							building_x = x
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - building_depth) / 2.0 + (Global.TILE_HEIGHT / 2.0)
							if tile.data[2] > 4:
								image = load("res://assets/building_assets/2d Assets/Occupied Shop.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")
						2:
							building_x = x - (((Global.TILE_WIDTH / 2.0) - building_width) / 2.0) - (building_width / 2.0)
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (building_depth / 2.0)
							if tile.data[2] > 8:
								image = load("res://assets/building_assets/2d Assets/Occupied Shop.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")
						3:
							building_x = x + (((Global.TILE_WIDTH / 2.0) - building_width) / 2.0) + (building_width / 2.0)
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (building_depth / 2.0)
							if tile.data[2] > 12:
								image = load("res://assets/building_assets/2d Assets/Occupied Shop.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")
				
					var currBuilding = Sprite.new()
					currBuilding.texture = image
					currBuilding.position = Vector2(building_x, building_y - 19)
					listOfBuildings.append(currBuilding)
					
			Tile.TileZone.SINGLE_FAMILY:
				building_width = Global.TILE_WIDTH / 4.0
				building_depth = building_width / 2.0
				building_height = 5
				
				if w > building_height:
					building_visible = false
				else:
					building_visible = true

				for z in num_buildings:
					var image
					
					match z:
						0:
							building_x = x
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - building_depth) / 2.0
							if tile.data[2] > 0:
								image = load("res://assets/building_assets/2d Assets/Occupied House.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")
						1:
							building_x = x
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - building_depth) / 2.0 + (Global.TILE_HEIGHT / 2.0)
							if tile.data[2] > 1:
								image = load("res://assets/building_assets/2d Assets/Occupied House.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")
						2:
							building_x = x - (((Global.TILE_WIDTH / 2.0) - building_width) / 2.0) - (building_width / 2.0)
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (building_depth / 2.0)
							if tile.data[2] > 2:
								image = load("res://assets/building_assets/2d Assets/Occupied House.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")
						3:
							building_x = x + (((Global.TILE_WIDTH / 2.0) - building_width) / 2.0) + (building_width / 2.0)
							building_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (building_depth / 2.0)
							if tile.data[2] > 3:
								image = load("res://assets/building_assets/2d Assets/Occupied House.png")
							else:
								image = load("res://assets/building_assets/2d Assets/Unoccupied Shop.png")

					var currBuilding = Sprite.new()
					currBuilding.texture = image
					currBuilding.position = Vector2(building_x, building_y - 19)
					listOfBuildings.append(currBuilding)

		# Draws a single building whose size is scaled to number of buildings
			Tile.TileZone.MULTI_FAMILY:
				# I'm guessing tile.data[2] = current num of residents, tile.data[3] = max num of residents
				building_width = (Global.TILE_WIDTH / 2.0) + (2 * num_buildings) 
				building_depth = building_width / 2.0
				building_height = 10 + (3 * num_buildings)

				if w > building_height:
					building_visible = false
				else:
					building_visible = true
				
				var currentHeight = 0
				var zIndex = 0
				
				building_x = x
				building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - (building_depth / 2.0))
				
				for numOfFullFloors in tile.data[2] / 4:
					var image = load("res://assets/building_assets/2d Assets/Full Apartment.png")
					var currBuilding = Sprite.new()
					currBuilding.texture = image
					currBuilding.position = Vector2(x, y - h - currentHeight)
					currBuilding.z_index = zIndex
					listOfBuildings.append(currBuilding)
					currentHeight += 16
					zIndex += 1
				
				var remainingResidents = tile.data[2] % 4
				var image
				
				if tile.data[3] - tile.data[2] > 0:
					if remainingResidents == 0:
						image = load("res://assets/building_assets/2d Assets/Empty Apartment.png")
					elif remainingResidents == 1:
						image = load("res://assets/building_assets/2d Assets/Quarter Apartment.png")
					elif remainingResidents == 2:
						image = load("res://assets/building_assets/2d Assets/Half Apartment.png")
					elif remainingResidents == 3:
						image = load("res://assets/building_assets/2d Assets/ThreeQuarter Apartment.png")
					
					var currBuilding = Sprite.new()
					currBuilding.texture = image
					currBuilding.position = Vector2(x, y - h - currentHeight)
					currBuilding.z_index = zIndex
					listOfBuildings.append(currBuilding)
	
	# Set the clickable area of the polygon (the entire base cube)
	coll.set_polygon(PoolVector2Array([
		Vector2(x, y - h), 
		Vector2(x + (Global.TILE_WIDTH / 2.0), y - h + (Global.TILE_HEIGHT / 2.0)), 
		Vector2(x + (Global.TILE_WIDTH / 2.0), y + (Global.TILE_HEIGHT / 2.0)), 
		Vector2(x, y + Global.TILE_HEIGHT), 
		Vector2(x - (Global.TILE_WIDTH / 2.0), y + (Global.TILE_HEIGHT/2.0)), 
		Vector2(x - (Global.TILE_WIDTH / 2.0), y - h + (Global.TILE_HEIGHT / 2.0)), 
		Vector2(x, y - h)
		]))

# Returns a buildings color based on tile status (occupied, damaged, etc.)
func get_building_colors():	
	# If damaged, return status color 
	match Global.tileMap[i][j].get_status():
		Tile.TileStatus.LIGHT_DAMAGE:
			return Tile.LIGHT_DAMAGE_COLOR
		Tile.TileStatus.MEDIUM_DAMAGE:
			return Tile.MEDIUM_DAMAGE_COLOR
		Tile.TileStatus.HEAVY_DAMAGE:
			return Tile.HEAVY_DAMAGE_COLOR

	# If building does not have utility
	if !Global.tileMap[i][j].utilities:
		return Tile.NO_UTILITIES_BUILDING_COLOR

	# Return building color based on zone
	return Tile.BUILDING_COLOR

# Returns cube colors for base cube
func get_cube_colors():
	var tile = Global.tileMap[i][j]
	var colors = []
	
	match tile.get_base():
		Tile.TileBase.DIRT:
			colors = Tile.DIRT_COLOR.duplicate(true)
			colors[0] = Tile.GRASS_COLOR[0]
			colors[3] = Tile.GRASS_COLOR[1]
		Tile.TileBase.ROCK:
			colors = Tile.ROCK_COLOR.duplicate(true)
		Tile.TileBase.SAND:
			colors = Tile.SAND_COLOR.duplicate(true)
		Tile.TileBase.OCEAN:
			colors = Tile.WATER_COLOR.duplicate(true)

	# Change base top color and outline if tile is zoned
	match tile.get_zone():
		Tile.TileZone.SINGLE_FAMILY:
			colors[0] = Tile.SINGLE_FAMILY_ZONE_COLOR[0]
			colors[3] = Tile.SINGLE_FAMILY_ZONE_COLOR[1]
		Tile.TileZone.MULTI_FAMILY:
			colors[0] = Tile.MULTI_FAMILY_ZONE_COLOR[0]
			colors[3] = Tile.MULTI_FAMILY_ZONE_COLOR[1]
		Tile.TileZone.COMMERCIAL:
			colors[0] = Tile.COM_ZONE_COLOR[0]
			colors[3] = Tile.COM_ZONE_COLOR[1]

	match tile.inf:
		Tile.TileInf.PARK:
			colors[0] = Tile.PARK_COLOR[0]
			colors[3] = Tile.PARK_COLOR[1]
		Tile.TileInf.ROAD:
			colors[0] = Tile.ROCK_COLOR[0]
		#Tile.TileInf.BRIDGE:
			#colors[0] = Tile.ROCK_COLOR[0]
	

	return colors

# Update the given tree based on its starting coordintes and properties
func update_tree(tree, tree_x, tree_y, width, depth, height, offset):
	# Left side of tree
	tree[0].set_polygon(PoolVector2Array([
		Vector2(tree_x, tree_y - height + (depth / 2.0)),
		Vector2(tree_x, tree_y - offset + depth),
		Vector2(tree_x - (width / 2.0), tree_y - offset + (depth / 2.0))
		]))
	# Right side of tree
	tree[1].set_polygon(PoolVector2Array([
		Vector2(tree_x, tree_y - height + (depth / 2.0)), 
		Vector2(tree_x, tree_y - offset + depth), 
		Vector2(tree_x + (width / 2.0), tree_y - offset + (depth / 2.0))
		]))

# Updates the provided rock [array of three polygons] given its starting point, width, depth, height, and height offset (for layers)
func update_rock(cube, cube_x, cube_y, width, depth, height, offset):
	# Top of cube
	cube[0].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - height), 
		Vector2(cube_x + (width / 2.0), cube_y - height + (depth / 2.0)), 
		Vector2(cube_x, cube_y - height + depth), 
		Vector2(cube_x - (width / 2.0), cube_y - height + (depth / 2.0)), 
		Vector2(cube_x, cube_y - height)
		]))
	
	# Left side of cube
	cube[1].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - offset + depth),
		Vector2(cube_x, cube_y - height + depth),
		Vector2(cube_x - (width / 2.0), cube_y - height + (depth / 2.0)),
		Vector2(cube_x - (width / 2.0), cube_y - offset + (depth / 2.0))
		]))
	
	# Right side of cube
	cube[2].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - height + depth), 
		Vector2(cube_x, cube_y - offset + depth), 
		Vector2(cube_x + (width / 2.0), cube_y - offset + (depth / 2.0)), 
		Vector2(cube_x + (width / 2.0), cube_y - height + (depth / 2.0))
		]))

# Updates the provided cube [array of three polygons] given its starting point, width, depth, height, and height offset (for layers)
func update_cube(cube, cube_x, cube_y, width, depth, height, offset, occupancy):
	# Top of cube
	cube[0].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - height), 
		Vector2(cube_x + (width / 2.0), cube_y - height + (depth / 2.0)), 
		Vector2(cube_x, cube_y - height + depth), 
		Vector2(cube_x - (width / 2.0), cube_y - height + (depth / 2.0)), 
		Vector2(cube_x, cube_y - height)
		]))
	
	# Left side of cube
	cube[1].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - offset + depth),
		Vector2(cube_x, cube_y - height + depth),
		Vector2(cube_x - (width / 2.0), cube_y - height + (depth / 2.0)),
		Vector2(cube_x - (width / 2.0), cube_y - offset + (depth / 2.0))
		]))
	
	# Right side of cube
	cube[2].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - height + depth), 
		Vector2(cube_x, cube_y - offset + depth), 
		Vector2(cube_x + (width / 2.0), cube_y - offset + (depth / 2.0)), 
		Vector2(cube_x + (width / 2.0), cube_y - height + (depth / 2.0))
		]))

	# If the height of the offset is higher, set cube heights to 0
	if offset >= (height * occupancy):
		height = 0
		offset = 0

	#I can't tell what these are doing, and if they're even useful. - Logan
	# Left side of cube (occupancy percentage)
	cube[3].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - offset + depth),
		Vector2(cube_x, cube_y - (height * occupancy) + depth),
		Vector2(cube_x - (width / 2.0), cube_y - (height * occupancy) + (depth / 2.0)),
		Vector2(cube_x - (width / 2.0), cube_y - offset + (depth / 2.0))
		]))

	# Right side of cube (occupancy percentage)
	cube[4].set_polygon(PoolVector2Array([
		Vector2(cube_x, cube_y - (height * occupancy) + depth), 
		Vector2(cube_x, cube_y - offset + depth), 
		Vector2(cube_x + (width / 2.0), cube_y - offset + (depth / 2.0)), 
		Vector2(cube_x + (width / 2.0), cube_y - (height * occupancy) + (depth / 2.0))
		]))

func set_index(a, b):
	self.i = a
	self.j = b
	x = (i * (Global.TILE_WIDTH / 2.0)) + (j * (-Global.TILE_WIDTH / 2.0))
	y = (i * (Global.TILE_HEIGHT / 2.0)) + (j * (Global.TILE_HEIGHT / 2.0))
	update_polygons()

# Changes x/y values without altering i/j values (used for camera rotation)
func adjust_coordinates(a, b):
	x = (a * (Global.TILE_WIDTH / 2.0)) + (b * (-Global.TILE_WIDTH / 2.0))
	y = (a * (Global.TILE_HEIGHT / 2.0)) + (b * (Global.TILE_HEIGHT / 2.0))
	update_polygons()

func is_valid_tile(i, j) -> bool:
	if i < 0 || Global.mapWidth <= i:
		return false
	if j < 0 || Global.mapHeight <= j:
		return false
	return true
