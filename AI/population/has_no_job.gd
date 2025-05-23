extends BTConditional


# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.


# The condition is checked BEFORE ticking. So it should be in _pre_tick.
# Checks if the queue is empty. If it is, do not proceed.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	var current_agent = blackboard.get_data("queue").front()
	#Checks if agent has a job
	if (current_agent.hasJob == false):
		#print("passed no_job")
		verified = true
	else:
		#print("failed no_job")
		verified = false
