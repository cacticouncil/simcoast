extends BTLeaf

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue").pop_front()

	# updates queue
	check_empty(blackboard)
	print("succeeded should_stay")
	#succeeds, if ticked
	return succeed()

# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue").empty()
	print(str("empty",empty))
	if empty:
		blackboard.set_data("queue_empty", true)
