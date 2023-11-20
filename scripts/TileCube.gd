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

var coll = CollisionPolygon2D.new()

func _ready():
	update_polygons()
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
		for b in objects:
			draw_polygon(b[1].get_polygon(), PoolColorArray([buildingColor[1]]))
			draw_polygon(b[2].get_polygon(), PoolColorArray([buildingColor[2]]))
			
			# If building is undamaged, draw occupancy percentage colors on the sides of the buildings
			if tile.get_status() == Tile.TileStatus.NONE:
				if tile.get_zone() == Tile.TileZone.LIGHT_RESIDENTIAL || tile.get_zone() == Tile.TileZone.HEAVY_RESIDENTIAL:
					draw_polygon(b[3].get_polygon(), PoolColorArray([Tile.RES_OCCUPANCY_COLOR[0]]))
					draw_polygon(b[4].get_polygon(), PoolColorArray([Tile.RES_OCCUPANCY_COLOR[1]]))
				elif tile.get_zone() == Tile.TileZone.LIGHT_COMMERCIAL || tile.get_zone() == Tile.TileZone.HEAVY_COMMERCIAL:
					draw_polygon(b[3].get_polygon(), PoolColorArray([Tile.COM_OCCUPANCY_COLOR[0]]))
					draw_polygon(b[4].get_polygon(), PoolColorArray([Tile.COM_OCCUPANCY_COLOR[1]]))
			
			draw_polygon(b[0].get_polygon(), PoolColorArray([buildingColor[0]]))
			draw_polyline(b[0].get_polygon(), buildingColor[3])
			
	elif tile.inf == Tile.TileInf.PARK:
		for t in objects:
			draw_polygon(t[0].get_polygon(), PoolColorArray([Tile.TREE_COLOR[0]]))
			draw_polygon(t[1].get_polygon(), PoolColorArray([Tile.TREE_COLOR[1]]))
			
	elif tile.inf == Tile.TileInf.UTILITIES_PLANT:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.UTILITIES_PLANT_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.UTILITIES_PLANT_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.UTILITIES_PLANT_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.UTILITIES_PLANT_COLOR[3])
		
		for s in objects:
			draw_polygon(s[1].get_polygon(), PoolColorArray([Tile.UTILITIES_STACK_COLOR[1]]))
			draw_polygon(s[2].get_polygon(), PoolColorArray([Tile.UTILITIES_STACK_COLOR[2]]))
			draw_polygon(s[0].get_polygon(), PoolColorArray([Tile.UTILITIES_STACK_COLOR[0]]))
			
	elif tile.inf == Tile.TileInf.SEWAGE_FACILITY:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.SEWAGE_FACILITY_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.SEWAGE_FACILITY_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.SEWAGE_FACILITY_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.SEWAGE_FACILITY_COLOR[3])
		
	elif tile.inf == Tile.TileInf.WASTE_TREATMENT:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.WASTE_TREATMENT_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.WASTE_TREATMENT_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.WASTE_TREATMENT_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.WASTE_TREATMENT_COLOR[3])
		
	elif tile.inf == Tile.TileInf.LIBRARY:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.LIBRARY_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.LIBRARY_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.LIBRARY_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.LIBRARY_COLOR[3])
		
	elif tile.inf == Tile.TileInf.MUSEUM:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.MUSEUM_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.MUSEUM_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.MUSEUM_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.MUSEUM_COLOR[3])
		
	elif tile.inf == Tile.TileInf.SCHOOL:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.SCHOOL_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.SCHOOL_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.SCHOOL_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.SCHOOL_COLOR[3])
		
	elif tile.inf == Tile.TileInf.FIRE_STATION:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.FIRE_STATION_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.FIRE_STATION_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.FIRE_STATION_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.FIRE_STATION_COLOR[3])
	elif tile.inf == Tile.TileInf.HOSPITAL:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.HOSPITAL_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.HOSPITAL_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.HOSPITAL_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.HOSPITAL_COLOR[3])
	elif tile.inf == Tile.TileInf.POLICE_STATION:
		var b = objects.pop_front()
		draw_polygon(b[1].get_polygon(), PoolColorArray([Tile.POLICE_STATION_COLOR[1]]))
		draw_polygon(b[2].get_polygon(), PoolColorArray([Tile.POLICE_STATION_COLOR[2]]))
		draw_polygon(b[0].get_polygon(), PoolColorArray([Tile.POLICE_STATION_COLOR[0]]))
		draw_polyline(b[0].get_polygon(), Tile.POLICE_STATION_COLOR[3])
	elif tile.inf == Tile.TileInf.BEACH_ROCKS:
		for r in objects:
			draw_polygon(r[1].get_polygon(), PoolColorArray([Tile.BEACH_ROCK_COLOR[1]]))
			draw_polygon(r[2].get_polygon(), PoolColorArray([Tile.BEACH_ROCK_COLOR[2]]))
			draw_polygon(r[0].get_polygon(), PoolColorArray([Tile.BEACH_ROCK_COLOR[0]]))
			
	elif tile.inf == Tile.TileInf.BEACH_GRASS:
		for g in objects:
			draw_polyline(g, Tile.TREE_COLOR[0])
			
	elif tile.inf == Tile.TileInf.ROAD:
		for r in objects:
			draw_polygon(r, PoolColorArray([Tile.ROAD_COLOR[0]]))
	elif tile.inf == Tile.TileInf.BRIDGE:
		draw_polygon(objects[0], PoolColorArray([Tile.BRIDGE_COLOR[1]]))
		for r in objects.slice(1, objects.size() - 1):
			draw_polygon(r, PoolColorArray([Tile.BRIDGE_COLOR[0]]))

func clear_objects():
	for o in objects:
		for p in o:
			if typeof(p) != TYPE_VECTOR2:
				p.queue_free()
	objects.clear()

func update_polygons():
	var tile = Global.tileMap[i][j]
	var h = tile.get_base_height()
	var w = tile.get_water_height()
	
	update_cube(base_cube, x, y, Global.TILE_WIDTH, Global.TILE_HEIGHT, h, 0, 0)
	update_cube(water_cube, x, y, Global.TILE_WIDTH, Global.TILE_HEIGHT, h + w, h, 0)
	
	# Create simple trees so landscape not so boring
	if tile.inf == Tile.TileInf.PARK:
		clear_objects()
		var tree_width = 0
		var tree_depth = 0
		var tree_height = 0
		var tree_x = 0
		var tree_y = 0
		
		for z in 3:
			var t = [Polygon2D.new(), Polygon2D.new()]
				
			match z:
				0:
					tree_height = 12
					if w >= tree_height:
						tree_height = 0
					
					tree_width = tree_height
					tree_depth = tree_width / 2.0
					
					tree_x = x + (Global.TILE_WIDTH / 4.0) - (tree_width / 2.0)
					tree_y = y - h + ((Global.TILE_HEIGHT / 2.5)) - (tree_depth / 2.0)
				1:
					tree_height = 16
					if w >= tree_height:
						tree_height = 0
					
					tree_width = tree_height
					tree_depth = tree_width / 2.0
					
					tree_x = x - (Global.TILE_WIDTH / 6.0)
					tree_y = y - h + (Global.TILE_HEIGHT / 2.5) - (tree_depth / 2.0)
				2:
					tree_height = 10
					if w >= tree_height:
						tree_height = 0
					
					tree_width = tree_height
					tree_depth = tree_width / 2.0
					
					tree_x = x
					tree_y = y - h + (0.7 * Global.TILE_HEIGHT) - (tree_depth / 2.0)
			
			update_tree(t, tree_x, tree_y, tree_width, tree_depth, tree_height, w)
			objects.append(t)
	
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
		
		var building_width = Global.TILE_WIDTH
		var building_depth = building_width / 2.0
		var building_height = 10

		if w > building_height:
			building_visible = false
		else:
			building_visible = true
		
		var b = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
			
		var building_x = x
		var building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - (building_depth / 2.0))

		update_cube(b, building_x, building_y, building_width, building_depth, building_height, w, 0)
		objects.append(b)
		
		if true:
			var stack_width = Global.TILE_WIDTH / 10.0
			var stack_depth = stack_width / 2.0
			var stack_height = 20
			
			for z in 4:
				var s = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
				var stack_x = 0
				var stack_y = 0
				
				match z:
					0:
						stack_x = x
						stack_y = y - h + ((Global.TILE_HEIGHT / 2.0) - stack_depth) / 2.0
					1:
						stack_x = x
						stack_y = y - h + ((Global.TILE_HEIGHT / 2.0) - stack_depth) / 2.0 + (Global.TILE_HEIGHT / 2.0)
					2:
						stack_x = x - (((Global.TILE_WIDTH / 2.0) - stack_width) / 2.0) - (stack_width / 2.0)
						stack_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (stack_depth / 2.0)
					3:
						stack_x = x + (((Global.TILE_WIDTH / 2.0) - stack_width) / 2.0) + (stack_width / 2.0)
						stack_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (stack_depth / 2.0)
			
				update_cube(s, stack_x, stack_y, stack_width, stack_depth, stack_height, building_height, 0)
				objects.append(s)
				
	elif tile.inf == Tile.TileInf.SEWAGE_FACILITY:
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
	
	elif tile.inf == Tile.TileInf.WASTE_TREATMENT:
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
	
	elif tile.inf == Tile.TileInf.LIBRARY:
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
		
	elif tile.inf == Tile.TileInf.MUSEUM:
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
	
	elif tile.inf == Tile.TileInf.SCHOOL:
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

	elif tile.inf == Tile.TileInf.FIRE_STATION:
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
	
	elif tile.inf == Tile.TileInf.HOSPITAL:
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
		
	elif tile.inf == Tile.TileInf.POLICE_STATION:
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

	# Draws roads depending on data values, which indicate which neighbords tile is connected to
	elif tile.inf == Tile.TileInf.ROAD:
		clear_objects()
		
		if w == 0:
			if tile.connections[(0 + Global.camDirection) % 4]:
				objects.append(PoolVector2Array([
					Vector2(x - (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (1.0 / 8.0))),
					Vector2(x - (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (3.0 / 8.0))),
					Vector2(x, y - h + (Global.TILE_HEIGHT * (6.0 / 8.0))),
					Vector2(x + (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
				]))
			if tile.connections[(1 + Global.camDirection) % 4]:
				objects.append(PoolVector2Array([
					Vector2(x + (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (1.0 / 8.0))),
					Vector2(x + (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (3.0 / 8.0))),
					Vector2(x, y - h + (Global.TILE_HEIGHT * (6.0 / 8.0))),
					Vector2(x - (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
				]))
			if tile.connections[(2 + Global.camDirection) % 4]:
				objects.append(PoolVector2Array([
					Vector2(x + (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (5.0 / 8.0))),
					Vector2(x + (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (7.0 / 8.0))),
					Vector2(x - (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0))),
					Vector2(x, y - h + (Global.TILE_HEIGHT * (2.0 / 8.0)))
				]))
			if tile.connections[(3 + Global.camDirection) % 4]:
				objects.append(PoolVector2Array([
					Vector2(x - (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (7.0 / 8.0))),
					Vector2(x - (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (5.0 / 8.0))),
					Vector2(x, y - h + (Global.TILE_HEIGHT * (2.0 / 8.0))),
					Vector2(x + (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
				]))
			if !tile.connections[0] && !tile.connections[1] && !tile.connections[2] && !tile.connections[3]:
				objects.append(PoolVector2Array([
					Vector2(x, y - h + (Global.TILE_HEIGHT * (2.0 / 8.0))),
					Vector2(x + (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0))),
					Vector2(x, y - h + (Global.TILE_HEIGHT * (6.0 / 8.0))),
					Vector2(x - (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
				]))
	elif tile.inf == Tile.TileInf.BRIDGE:
		clear_objects()
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
		
		objects.append(PoolVector2Array([
			Vector2(cube_x, cube_y - building_height), 
			Vector2(cube_x + (building_width / 2.0), cube_y - building_height + (building_depth / 2.0)), 
			Vector2(cube_x, cube_y - building_height + building_depth), 
			Vector2(cube_x - (building_width / 2.0), cube_y - building_height + (building_depth / 2.0)), 
			Vector2(cube_x, cube_y - building_height)
			]))
		
		if tile.connections[(0 + Global.camDirection) % 4]:
			objects.append(PoolVector2Array([
				Vector2(x - (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (1.0 / 8.0))),
				Vector2(x - (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (3.0 / 8.0))),
				Vector2(x, y - h + (Global.TILE_HEIGHT * (6.0 / 8.0))),
				Vector2(x + (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
			]))
		if tile.connections[(1 + Global.camDirection) % 4]:
			objects.append(PoolVector2Array([
				Vector2(x + (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (1.0 / 8.0))),
				Vector2(x + (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (3.0 / 8.0))),
				Vector2(x, y - h + (Global.TILE_HEIGHT * (6.0 / 8.0))),
				Vector2(x - (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
			]))
		if tile.connections[(2 + Global.camDirection) % 4]:
			objects.append(PoolVector2Array([
				Vector2(x + (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (5.0 / 8.0))),
				Vector2(x + (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (7.0 / 8.0))),
				Vector2(x - (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0))),
				Vector2(x, y - h + (Global.TILE_HEIGHT * (2.0 / 8.0)))
			]))
		if tile.connections[(3 + Global.camDirection) % 4]:
			objects.append(PoolVector2Array([
				Vector2(x - (Global.TILE_WIDTH * (1.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (7.0 / 8.0))),
				Vector2(x - (Global.TILE_WIDTH * (3.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (5.0 / 8.0))),
				Vector2(x, y - h + (Global.TILE_HEIGHT * (2.0 / 8.0))),
				Vector2(x + (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
			]))
		if !tile.connections[0] && !tile.connections[1] && !tile.connections[2] && !tile.connections[3]:
			objects.append(PoolVector2Array([
				Vector2(x, y - h + (Global.TILE_HEIGHT * (2.0 / 8.0))),
				Vector2(x + (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0))),
				Vector2(x, y - h + (Global.TILE_HEIGHT * (6.0 / 8.0))),
				Vector2(x - (Global.TILE_WIDTH * (2.0 / 8.0)), y - h + (Global.TILE_HEIGHT * (4.0 / 8.0)))
			]))
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
	
	# Generate building polygons depending on density and water height
	elif tile.has_building():
		clear_objects()
		var num_buildings = tile.get_number_of_buildings()
		
		var building_width = 0
		var building_depth = 0
		var building_height = 0
		var building_x = 0
		var building_y = 0

		if tile.is_light_zoned():
			building_width = Global.TILE_WIDTH / 4.0
			building_depth = building_width / 2.0
			building_height = 5
			
			if w > building_height:
				building_visible = false
			else:
				building_visible = true
			
			for z in num_buildings:
				var b = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
				var occupancy = 0.0
				
				match z:
					0:
						building_x = x
						building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - building_depth) / 2.0
						if tile.data[2] > 0:
							occupancy = 1.0
					1:
						building_x = x
						building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - building_depth) / 2.0 + (Global.TILE_HEIGHT / 2.0)
						if tile.data[2] > 4:
							occupancy = 1.0
					2:
						building_x = x - (((Global.TILE_WIDTH / 2.0) - building_width) / 2.0) - (building_width / 2.0)
						building_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (building_depth / 2.0)
						if tile.data[2] > 8:
							occupancy = 1.0
					3:
						building_x = x + (((Global.TILE_WIDTH / 2.0) - building_width) / 2.0) + (building_width / 2.0)
						building_y = y - h + ((Global.TILE_HEIGHT / 2.0)) - (building_depth / 2.0)
						if tile.data[2] > 12:
							occupancy = 1.0
			
				update_cube(b, building_x, building_y, building_width, building_depth, building_height, w, occupancy)
				objects.append(b)

		# Draws a single building whose size is scaled to number of buildings
		elif tile.is_heavy_zoned():
			building_width = (Global.TILE_WIDTH / 2.0) + (2 * num_buildings) 
			building_depth = building_width / 2.0
			building_height = 10 + (3 * num_buildings)

			if w > building_height:
				building_visible = false
			else:
				building_visible = true
			
			var occupancy = 0
			if tile.data[3] != 0:
				occupancy = float(tile.data[2]) / float(tile.data[3])
			
			var b = [Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new(), Polygon2D.new()]
			
			building_x = x
			building_y = y - h + ((Global.TILE_HEIGHT / 2.0) - (building_depth / 2.0))

			update_cube(b, building_x, building_y, building_width, building_depth, building_height, w, occupancy)

			objects.append(b)
	
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
		Tile.TileZone.LIGHT_RESIDENTIAL:
			colors[0] = Tile.LT_RES_ZONE_COLOR[0]
			colors[3] = Tile.LT_RES_ZONE_COLOR[1]
		Tile.TileZone.HEAVY_RESIDENTIAL:
			colors[0] = Tile.HV_RES_ZONE_COLOR[0]
			colors[3] = Tile.HV_RES_ZONE_COLOR[1]
		Tile.TileZone.LIGHT_COMMERCIAL:
			colors[0] = Tile.LT_COM_ZONE_COLOR[0]
			colors[3] = Tile.LT_COM_ZONE_COLOR[1]
		Tile.TileZone.HEAVY_COMMERCIAL:
			colors[0] = Tile.HV_COM_ZONE_COLOR[0]
			colors[3] = Tile.HV_COM_ZONE_COLOR[1]

	match tile.inf:
		Tile.TileInf.PARK:
			colors[0] = Tile.PARK_COLOR[0]
			colors[3] = Tile.PARK_COLOR[1]
		Tile.TileInf.ROAD:
			colors[0] = Tile.ROCK_COLOR[0]
		#Tile.TileInf.BRIDGE:
			#colors[0] = Tile.ROCK_COLOR[0]
	
	match tile.sensor:
		Tile.TileSensor.TIDE:
			colors[0] = Color("fff542a4")

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
