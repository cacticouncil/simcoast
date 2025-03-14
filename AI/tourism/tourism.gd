extends Node


# Need to test to see if this AI is appropriate as a singleton or a child node


# Sets up primary blackboard values
func _ready():
	$Blackboard.set_data("queue3", [])
	$Blackboard.set_data("queue3_empty", true)


# Checks if the AI's agent queue is empty
func _process(delta):
	if $Blackboard.get_data("queue3_empty") == true:
		update_AI()
	

# Obtains a new agent queue and sets it in the blackboard	
func update_AI():
	var latest = update_queue()
	if latest.size() != 0:
		$Blackboard.set_data("queue3", latest)
		$Blackboard.set_data("queue3_empty", false)
	

# Refills the zone queue
func update_queue() -> Array:
#func add_agent(i, j):
#	var tile = Global.tileMap[i][j]
#	var newAgent = load("res://AI/population/Agent.gd")
#	var currentAgent = newAgent.new(tile)
#	ActiveAgents.append(currentAgent)
#	print("done")

	var activeAgents = UpdateTourist.ActiveTourists
	var latest = []
	
	for i in activeAgents.size():
		var current = activeAgents[i]
		latest.push_back(current)
		
	return latest
