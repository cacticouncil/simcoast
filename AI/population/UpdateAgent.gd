extends Node

var ActiveAgents = []
var totalJobs = 0
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
