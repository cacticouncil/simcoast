extends Node

var ActiveTourists = []

#Add Tourists in
func add_tourist(i, j):
	var tile = Global.tileMap[i][j]
	var newAgent = load("res://AI/tourism/TourismAgent.gd")
	var currentAgent = newAgent.new(tile)
	ActiveTourists.append(currentAgent)
#Clear tourists
func clear_tourists():
	ActiveTourists.clear()
#Amount of tourists currently in the city
func total_agents():
	return ActiveTourists.size()
