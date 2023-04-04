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
			# if there are no higher water tiles around, check if water needs to disapate
			if highest == 0:
				pass
			# if tile is an ocean tile raise its water height if there are higher water tiles adjacent
			elif currTile.base == Tile.TileBase.OCEAN:
				return
			else:
				return

func find_highest_water(tile):
	var highest = tile
	# Only checking for 4 cardinal directions, can be changed if needed
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
	for n in neighbors:
		if UpdateValue.is_valid_tile(n[0], n[1]):
			var nwaterheight = Global.tileMap[n[0]][n[1]].waterheight
			var nbaseheight = Global.tileMap[n[0]][n[1]].baseheight
			# If neighbor is taller and has water that can spread set it to highest
			if nbaseheight + nwaterheight > highest.baseheight + highest.waterheight && nwaterheight > 1:
				highest = Global.tileMap[n[0]][n[1]]
	if highest == tile:
		return 0
	else:
		return highest.waterheight + highest.baseheight
	
#Update waves
func update_waves():
	if Global.oceanHeight == 0:
			Global.oceanHeight = 1
	Global.oceanHeight += (1 * waterDir)
	City.updateOceanHeight(waterDir);
	if Global.oceanHeight <= 1 || Global.oceanHeight >= 5:
		waterDir *= -1
