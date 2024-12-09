extends BTConditional


# A conditional node MUST NOT override _tick but only 
# _pre_tick and _post_tick.

var BASE_LEAVE_CHANCE = 0.01
var BASE_STAY_CHANCE = 0.01
var NO_UTILITIES_UNHAPPINESS = 10
var DAMAGE_UNHAPPINESS = 10
var SEVERE_DAMAGE_UNHAPPINESS = 30
# The condition is checked BEFORE ticking. So it should be in _pre_tick.
# Checks if the queue is empty. If it is, do not proceed.
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
	var current_agent = blackboard.get_data("queue").front()
	var currTile = current_agent.residential_tile
	var leaveChance = 0
	var status = currTile.get_status()
	var selectTile = BASE_STAY_CHANCE * (currTile.landValue + currTile.happiness)
	if (!currTile.has_utilities()):
		leaveChance += NO_UTILITIES_UNHAPPINESS 
	if (status == Tile.TileStatus.LIGHT_DAMAGE || status == Tile.TileStatus.MEDIUM_DAMAGE):
		leaveChance += DAMAGE_UNHAPPINESS
	elif (status == Tile.TileStatus.HEAVY_DAMAGE):
		leaveChance += SEVERE_DAMAGE_UNHAPPINESS
	if (selectTile * leaveChance > 0.5):
		print("failed is_happy")
		verified = false
	else:
		print("passed is_happy")
		verified = true
