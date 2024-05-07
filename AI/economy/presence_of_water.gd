extends BTLeaf


const INNER_NEIGHBOR = 0.10
const OUTER_NEIGHBOR = 0.5


# Currently this does nothing, but if I delete it then the desirability behavior tree stops working
# so, it stays for now
func _tick(agent: Node, blackboard: Blackboard) -> bool:
						
	return succeed()


# Check to see if these indices are valid tile coordinates
func is_valid_tile(i, j) -> bool:
	if i < 0 || Global.mapHeight <= i:
		return false
	if j < 0 || Global.mapWidth <= j:
		return false
	return true
