extends BTConditional


# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.

var BASE_MOVE_CHANCE = 0.01
var BASE_STAY_CHANCE = 0.01
var NO_UTILITIES_UNHAPPINESS = 10
var DAMAGE_UNHAPPINESS = 10
var SEVERE_DAMAGE_UNHAPPINESS = 30
# The condition is checked BEFORE ticking. So it should be in _pre_tick.
# Checks if the queue is empty. If it is, do not proceed.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	var current_agent = blackboard.get_data("queue2").front()
	var currTile = current_agent.residential_tile
	var selectTile = BASE_MOVE_CHANCE * (currTile.landValue + currTile.happiness)
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth
	var moved = false
	# iterates through the map to find possible better living spaces
	for i in mapHeight:
		for j in mapWidth:
			if moved == false:
				var current_tile = Global.tileMap[i][j]
				var maxRange = current_tile.landValue + current_tile.happiness
				var select_tile = BASE_MOVE_CHANCE * (current_tile.landValue + current_tile.happiness)
			
				if current_tile.TileZone == Tile.TileZone.MULTI_FAMILY || current_tile.TileZone == Tile.TileZone.SINGLE_FAMILY:
					if current_tile.has_utilities() && current_tile.tileDamage == 0:
						# if living space is suitable and chance of moving allows for move to happen, move agent
						if (select_tile > selectTile):
							UpdateAgent.ActiveAgents.find(current_agent).residential_tile = current_tile
							moved = true
							break
	if (moved == true):
		print("passed should_move")
		verified = true
	else:
		print("failed should_move")
		verified = false
