extends Node

#Update graphics
func update_graphics():
	# Update all tiles
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			Global.tileMap[i][j].cube.update()
