extends Node

#temp var for ocean level directions
var waterDir = 1

func update_water_spread():
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth

	for i in mapHeight:
		for j in mapWidth:
			var currTile = Global.tileMap[i][j]
			var highest = find_highest_water(currTile)
			# adjust water height to be one unit lower than the highest adjacent tile
			currTile.changeInWaterHeight = (highest - 1) - currTile.baseHeight
			currTile.waterHeight = (highest - 1) - currTile.baseHeight
			# if current tile has no water neighbors, water should be removed (oceans will NOT be affected by this)
			if currTile.waterHeight < 0:
				currTile.waterHeight = 0

# returns total height of the highest tile around the current tile (water + base)
func find_highest_water(tile):
	var highest = tile
	# Only checking for 4 cardinal directions, can be changed if needed
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
	for n in neighbors:
		if UpdateValue.is_valid_tile(n[0], n[1]):
			var nwaterheight = Global.tileMap[n[0]][n[1]].waterHeight
			var nbaseheight = Global.tileMap[n[0]][n[1]].baseHeight
			# If neighbor is taller and has water that can spread set it to highest (oceans can always spread water)
			if nbaseheight + nwaterheight > highest.baseHeight + highest.waterHeight && \
			(nwaterheight > 1 || Global.tileMap[n[0]][n[1]].base == Tile.TileBase.OCEAN):
				highest = Global.tileMap[n[0]][n[1]]
	# if no higher tile was found, return 0
	if highest == tile:
		return 0
	else:
		return highest.waterHeight + highest.baseHeight
