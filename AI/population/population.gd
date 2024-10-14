extends Node


# Need to test to see if this AI is appropriate as a singleton or a child node


# Sets up primary blackboard values
func _ready():
	$Blackboard.set_data("queue", [])
	$Blackboard.set_data("queue_empty", true)


# Checks if the AI's tile queue is empty
func _process(delta):
	if $Blackboard.get_data("queue_empty") == true:
		update_AI()
	

# Obtains a new tile queue and sets it in the blackboard	
func update_AI():
	var latest = update_queue()
	if latest.size() != 0:
		$Blackboard.set_data("queue", latest)
		$Blackboard.set_data("queue_empty", false)
	

# Refills the zone queue
func update_queue() -> Array:
	# Because the map is scalable, update map dimensions
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth
	var latest = []
	for i in mapHeight:
		for j in mapWidth:
			var current = Global.tileMap[i][j]
			var accept		
			# Check tile zone type. If it's zoned, accept the tile into the queue
			if current.is_zoned():
				accept = true
			else:
				accept = false
			if accept:
				latest.push_back(current)
	return latest
