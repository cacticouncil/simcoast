extends BTConditional

# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.


# The condition is checked BEFORE ticking. So it should be in _pre_tick.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	var current_agent = blackboard.get_data("queue").front()
	var unbalanced_col = false
	#Checks if COL is unbalanced
	if (current_agent.level == Agent.JOBS.LOW && current_agent.col_level == Agent.COL.HIGH):
		unbalanced_col = true
	elif (current_agent.level == Agent.JOBS.HIGH && current_agent.col_level == Agent.COL.LOW):
		unbalanced_col = true
	if (unbalanced_col == true):
		#print("unbalanced")
		verified = true
	else:
		#print("failed should_move")
		verified = false
