extends Node

var ActiveAgents = []

func add_agent(i, j):
	var tile = Global.tileMap[i][j]
	var newAgent = load("res://AI/population/Agent.gd")
	var currentAgent = newAgent.new(tile)
	ActiveAgents.append(currentAgent)
	print("done")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
