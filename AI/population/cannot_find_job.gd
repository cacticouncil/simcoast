extends BTConditional


# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.

# The condition is checked BEFORE ticking. So it should be in _pre_tick.
# Checks if the queue is empty. If it is, do not proceed.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	if UpdateAgent.can_work():
		print("failed cannot_find_job")
		verified = false
	else:
		print("passed cannot_find_job")
		verified = true
