extends BTLeaf


var BASE_MOVE_CHANCE = 0.01
var rng = RandomNumberGenerator.new()

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue").pop_front()
	if current_agent.unemployed_month == null:
		current_agent.unemployed_month = UpdateDate.month
	elif current_agent.unemployed_month != UpdateDate.month:
		current_agent.unemployed_month = UpdateDate.month
		current_agent.months_passed +=1

	if current_agent.months_passed > 6:
		var currTile = current_agent.residential_tile
		currTile.remove_people(1)
		UpdateAgent.ActiveAgents.erase(current_agent)

	# updates queue
	check_empty(blackboard)
	#print("succeeded cannot_find_job")
	#succeeds, if ticked
	return succeed()

# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue").empty()
	#print(str("empty",empty))
	if empty:
		blackboard.set_data("queue_empty", true)
