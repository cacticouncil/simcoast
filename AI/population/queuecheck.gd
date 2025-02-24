extends BTConditional


# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.


# The condition is checked BEFORE ticking. So it should be in _pre_tick.
# Checks if the queue is empty. If it is, do not proceed.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	var queue_empty = blackboard.get_data("queue2_empty")
	if queue_empty:
		print("failed queue empty")
		verified = false
	else:
		print("passed queue empty")
		verified = true
