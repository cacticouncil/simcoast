extends BTLeaf



func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue").pop_front()
	if (current_agent.level == Agent.JOBS.LOW && current_agent.col_level == Agent.COL.HIGH):
		#Wants to find new job or move
		for key in Global.activeTiles:
			var tile = Global.tileMap[key[0]][key[1]]
			if (tile.is_residential() && tile.desirability < current_agent.residential_tile.desirability && tile.data[2] < tile.data[3]):
				current_agent.change_residence(tile)
				break
	elif (current_agent.level == Agent.JOBS.HIGH && current_agent.col_level == Agent.COL.LOW):
		#Wants to find more desirable place to live
		for key in Global.activeTiles:
			var tile = Global.tileMap[key[0]][key[1]]
			if (tile.is_residential() && tile.desirability > current_agent.residential_tile.desirability && tile.data[2] < tile.data[3]):
				current_agent.change_residence(tile)
				break
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
