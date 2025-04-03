extends Node

var ActiveTourists = []

func add_tourist(i, j):
	var tile = Global.tileMap[i][j]
	var newAgent = load("res://AI/tourism/TourismAgent.gd")
	var currentAgent = newAgent.new(tile)
	ActiveTourists.append(currentAgent)
func clear_tourists():
	ActiveTourists.clear()
func total_agents():
	return ActiveTourists.size()
