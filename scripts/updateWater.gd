extends Node

#temp var for ocean level directions
var waterDir = 1

func update_water_spread():
	# if tile is an ocean tile raise its water height if there are higher water tiles adjacent
	# else if tile is not already flooded and adjacent tile has water that can spread (water height > 1) then spread water here
	return

func find_highest_water(tile):
	var highest = Tile
	# Only checking for 4 cardinal directions, can be changed if needed
	var neighbors = [[tile.i-1, tile.j], [tile.i+1, tile.j], [tile.i, tile.j-1], [tile.i, tile.j+1]]
	for n in neighbors:
			if UpdateValue.is_valid_tile(n[0], n[1]):
				return
	return
	
#Update waves
func update_waves():
	if Global.oceanHeight == 0:
			Global.oceanHeight = 1
	Global.oceanHeight += (1 * waterDir)
	City.updateOceanHeight(waterDir);
	if Global.oceanHeight <= 1 || Global.oceanHeight >= 5:
		waterDir *= -1
