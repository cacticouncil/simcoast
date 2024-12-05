extends Node

func update_erosion():
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth

	for i in mapHeight:
		for j in mapWidth:
			var currTile = Global.tileMap[i][j]
			# erosion rate determined by tile base and num of adjacent water tiles
			if currTile.base != Tile.TileBase.OCEAN:
				var waterPresence = calc_water_neighbors(currTile)
				if currTile.base == Tile.TileBase.DIRT:
					currTile.erosion += 0.00001 * waterPresence
				elif currTile.base == Tile.TileBase.ROCK:
					currTile.erosion += 0.000005 * waterPresence
				elif currTile.base == Tile.TileBase.SAND:
					currTile.erosion += 0.00002 * waterPresence
			# if tile reaches max erosion, reduce height of tile and reset
			if currTile.erosion >= 100:
				currTile.erosion = 0
				# TENTATIVE IMPLEMENTATION: If tile is completely eroded away, it becomes an OCEAN tile (water source tile). 
				if currTile.baseHeight == 0:
					currTile.base = Tile.TileBase.OCEAN
					# These two lines are necessary since currently OCEAN tiles don't actually use waterHeight, only baseHeight.
					currTile.baseHeight = currTile.waterHeight
					currTile.waterHeight = 0
				# otherwise just reduce height of tile
				else:
					currTile.baseHeight -= 1
func update_erosion_tile(currTile):
	 # erosion rate determined by tile base and num of adjacent water tiles
	if currTile.base != Tile.TileBase.OCEAN:
		var waterPresence = calc_water_neighbors(currTile)
		if currTile.base == Tile.TileBase.DIRT:
			currTile.erosion += 0.00001 * waterPresence
		elif currTile.base == Tile.TileBase.ROCK:
			currTile.erosion += 0.000005 * waterPresence
		elif currTile.base == Tile.TileBase.SAND:
			currTile.erosion += 0.00002 * waterPresence
		# if tile reaches max erosion, reduce height of tile and reset
	if currTile.erosion >= 100:
		currTile.erosion = 0
		# TENTATIVE IMPLEMENTATION: If tile is completely eroded away, it becomes an OCEAN tile (water source tile). 
		if currTile.baseHeight == 0:
			currTile.base = Tile.TileBase.OCEAN
			# These two lines are necessary since currently OCEAN tiles don't actually use waterHeight, only baseHeight.
			currTile.baseHeight = currTile.waterHeight
			currTile.waterHeight = 0
		# otherwise just reduce height of tile
		else:
			currTile.baseHeight -= 1
func calc_water_neighbors(tile):
	# check 4 adjacent tiles for water
	var numWaterTiles = 0
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
	for n in neighbors:
			if UpdateValue.is_valid_tile(n[0], n[1]):
				# if the adjecent tiles are an ocean tile
				# or their waterHeight is not 0 (tile is flooded) proc erosion
				if Global.tileMap[n[0]][n[1]].base == Tile.TileBase.OCEAN \
				|| Global.tileMap[n[0]][n[1]].waterHeight > 0:
					numWaterTiles += 1
				
	return numWaterTiles
