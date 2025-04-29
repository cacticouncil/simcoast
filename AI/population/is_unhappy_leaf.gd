extends BTLeaf


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var BASE_MOVE_CHANCE = 0.01
var rng = RandomNumberGenerator.new()

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue").pop_front()
	#Agent will move if they are unhappy or leave the city
	var moved = false

	# iterates through the map to find possible living spaces
	for key in Global.activeTiles:
			if moved == false:
				var current_tile = Global.tileMap[key[0]][key[1]]
				var maxRange = current_tile.happiness + current_tile.landValue
				var selectTile = BASE_MOVE_CHANCE * (current_tile.landValue + current_tile.happiness)

				if current_tile.zone == Tile.TileZone.MULTI_FAMILY || current_tile.zone == Tile.TileZone.SINGLE_FAMILY:
					if current_tile.has_utilities() && current_tile.tileDamage == 0:
						rng.randomize()
						# if living space is suitable and chance of moving allows for move to happen, move agent
						if (selectTile > rng.randf_range(0,maxRange)):
							current_agent.change_residence(current_tile)
							moved = true
							break

	# if no suitable living space, agent leaves city
	if moved == false:
		print("agent left city")
		var currTile = current_agent.residential_tile
		currTile.move_people_out(1)
		UpdatePopulation.change_residents(-1)
		
		var currWorkTile = current_agent.commercial_tile
		if currWorkTile != null:
			current_agent.removeJob()
			#currWorkTile.remove_people(1)
		UpdateAgent.ActiveAgents.erase(current_agent)
		print("agents:", UpdateAgent.ActiveAgents.size())

	# updates queue
	check_empty(blackboard)
	#print("succeeded is_unhappy")
	#succeeds, if ticked
	return succeed()

# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue").empty()
	#print(str("empty",empty))
	if empty:
		blackboard.set_data("queue_empty", true)
