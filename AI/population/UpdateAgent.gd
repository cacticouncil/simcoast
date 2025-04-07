extends Node

var ActiveAgents = []
var totalJobs = 0
var numBeachWorkers = 3
var numBeachManagers = 1
#above 10% unemployment and people are unhappy 
var UNEMPLOYMENT_LIMIT = .10

func add_agent(i, j):
	var tile = Global.tileMap[i][j]
	var newAgent = load("res://AI/population/Agent.gd")
	var currentAgent = newAgent.new(tile)
	ActiveAgents.append(currentAgent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func total_agents():
	#print(ActiveAgents.size())
	return ActiveAgents.size()

func can_work():
	var p = total_agents()
	if p == 0:
		return false
	if (1-totalJobs/p) > UNEMPLOYMENT_LIMIT:
		return true
	else:
		return false

func increase_total_jobs():
	totalJobs = totalJobs + 1;

func  decrease_total_jobs():
	totalJobs = totalJobs - 1;
	
func onRemovedTile(i, j):
	for agent in ActiveAgents:
		if (agent.residential_tile.i == i && agent.residential_tile.j == j):
			var currTile = agent.residential_tile
			currTile.remove_people(1)
			agent.removeJob()
			ActiveAgents.erase(agent)
		if (agent.commercial_tile != null):
			if (agent.commercial_tile.i == i && agent.commercial_tile.j == j):
				print("lost job")
				agent.removeJob()
#Gets average happiness of agents living in that tile
func getAverageHappiness(i, j):
	var totalHappiness = 0
	var numAgents = 0
	for agent in ActiveAgents:
		if (agent.residential_tile.i == i && agent.residential_tile.j == j):
			totalHappiness += agent.happiness
			numAgents += 1
	if (numAgents == 0):
		return 0
	else:
		return totalHappiness / numAgents
