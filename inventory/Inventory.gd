extends Node

var items = {
	"utility plant": 1,
	'fire station': 0,
	'hospital': 0,
	'police station': 0,
	'sewage facility': 0,
	'waste treatment': 0,
	'park': 2,
	'library': 0,
	'museum': 0,
	'school': 0,
	'road': 10,
	'water': 0,
	'bridge': 0,
	'house': 0, #don't use
	'apartment': 0, #don't use
	'shop': 0, #don't use
	'super shop': 0, #don't use
	'lt_res_zone': 0, #don't use
	'hv_res_zone': 0, #don't use
	'lt_com_zone': 0, #don't use
	'hv_com_zone': 0 #don't use
}

func add_building(building):
	items[building] += 1
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

func remove_building(building):
	items[building] -= 1
	get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()

func removeIfHave(building):
	#Used to check if we have a building, remove it if we do. Returns true if sucessful
	if items[building] > 0:
		items[building] -= 1
		get_node("/root/CityMap/HUD/ToolsMenu").updateAmounts()
		return true
	return false

func get_number_of_buildings(building):
	return items[building]

func has_building(building):
	return items[building] > 0
