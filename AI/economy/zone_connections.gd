extends BTLeaf


# How many neighbors of each zone type will affect desirability
const NEIGHBOR_CAP = 3


# What other tiles/zones are connected to this tile
func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var tile = blackboard.get_data("queue").front()
	var residential_neighbor = 0
	var commercial_neighbor = 0
	var industrial_neighbor = 0
	var public_works_neighbors = 0
	
	# Get all neighbors in a circular radius.
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1],
			[tile.i-2, tile.j], [tile.i+2, tile.j], [tile.i, tile.j-2], [tile.i, tile.j+2],
			[tile.i+1, tile.j+1], [tile.i-1, tile.j+1], [tile.i-1, tile.j-1], [tile.i+1, tile.j-1]]
			
	for n in neighbors:
		if is_valid_tile(n[0], n[1]):
			# Check if it's a utility plant
			if Global.tileMap[n[0]][n[1]].inf == Tile.TileInf.UTILITIES_PLANT:
				industrial_neighbor += 1
				continue
			
			# Check what type of zone the neighbor is
			var neighbor = Global.tileMap[n[0]][n[1]]
			match(neighbor.zone):
				Tile.TileZone.SINGLE_FAMILY:
					residential_neighbor += 1
				Tile.TileZone.MULTI_FAMILY:
					residential_neighbor += 2
				Tile.TileZone.COMMERCIAL:
					commercial_neighbor += 	1
				Tile.TileZone.PUBLIC_WORKS:
					public_works_neighbors += 1
				_:
					continue
	
	# Check if number of zone neighbors exceed value cap			
	if residential_neighbor > NEIGHBOR_CAP:
		residential_neighbor = NEIGHBOR_CAP
	if commercial_neighbor > NEIGHBOR_CAP:
		commercial_neighbor = NEIGHBOR_CAP
	if industrial_neighbor > NEIGHBOR_CAP:
		industrial_neighbor = NEIGHBOR_CAP
	if public_works_neighbors > NEIGHBOR_CAP:
		public_works_neighbors = NEIGHBOR_CAP
		
	tile.residential_neighbors = residential_neighbor
	tile.commercial_neighbors = commercial_neighbor
	tile.industrial_neighbors = industrial_neighbor
	tile.public_works_neighbors = public_works_neighbors
	
	return succeed()


# Check to see if these indices are valid tile coordinates
func is_valid_tile(i, j) -> bool:
	if i < 0 || Global.mapWidth <= i:
		return false
	if j < 0 || Global.mapHeight <= j:
		return false
	return true
