extends BTConditional


# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.


# The condition is checked BEFORE ticking. So it should be in _pre_tick.
# Checks if the queue is empty. If it is, do not proceed.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	var tile = blackboard.get_data("queue").front()
	if tile.zone == Tile.TileZone.SINGLE_FAMILY || tile.zone == Tile.TileZone.MULTI_FAMILY:
		verified = false
	else:
		verified = true
