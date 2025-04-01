class_name TourismAgent
extends Node

#What chance they have to purchase something
var purchaseChance = 0
#What chance they have to drop trash
var litterChance = 0
#Where the tourist is
var location = null
var rng = RandomNumberGenerator.new()
func _init(tile):
	location = tile
	purchaseChance = rng.randf_range(0.05, 0.1)
	litterChance = rng.randf_range(0.005, 0.01)
