extends BTLeaf

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue3").front()
	#Tourist didn't litter
	# updates queue
	check_empty(blackboard)

	#succeeds, if ticked
	return succeed()

# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue3").empty()
	if empty:
		blackboard.set_data("queue3_empty", true)
