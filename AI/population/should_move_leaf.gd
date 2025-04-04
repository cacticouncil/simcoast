extends BTLeaf


var BASE_MOVE_CHANCE = 0.01
var rng = RandomNumberGenerator.new()

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue").pop_front()
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth
	var moved = false

	# iterates through the map to find possible living spaces
	for i in mapHeight:
		for j in mapWidth:
			var current_tile = Global.tileMap[i][j]
			var maxRange = current_tile.landValue + current_tile.happiness
			var selectTile = BASE_MOVE_CHANCE * (current_tile.landValue + current_tile.happiness)

			if current_tile.zone == Tile.TileZone.MULTI_FAMILY || current_tile.zone == Tile.TileZone.SINGLE_FAMILY:
				if current_tile.has_utilities() && current_tile.tileDamage == 0:
					rng.randomize()
					# if living space is suitable and chance of moving allows for move to happen, move agent
					if (selectTile > rng.randf_range(0, maxRange)):
						current_agent.change_residence(current_tile)
						moved = true
						break

	# if no suitable living space, agent leaves city
	if moved == false:
		var currTile = current_agent.residential_tile
		currTile.remove_people(1)
		UpdateAgent.ActiveAgents.erase(current_agent)

	# updates queue
	check_empty(blackboard)
	#print("succeeded should_move")
	#succeeds, if ticked
	return succeed()

# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue").empty()
	#print(str("empty",empty))
	if empty:
		blackboard.set_data("queue_empty", true)
