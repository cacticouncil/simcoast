extends BTLeaf

var rng = RandomNumberGenerator.new()

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue3").pop_front()
	#Should affect economy
	var price = rng.randi_range(1, 10)
	#Give player money from tourist purchase
	Econ.adjust_player_money(price)
	# updates queue
	check_empty(blackboard)
	
	#succeeds, if ticked
	return succeed()

# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue3").empty()
	if empty:
		blackboard.set_data("queue3_empty", true)
