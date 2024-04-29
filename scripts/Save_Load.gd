extends Node

func _ready():
	pass

func saveData(mapPath: String):
	var correctMapName = mapPath.trim_suffix(".json")
	correctMapName = correctMapName.trim_prefix("user://saves/")
	if not (".json" in mapPath):
		mapPath += ".json"
	var tileData = []
	
	Global.currentMap = mapPath
	
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			tileData.append(Global.tileMap[i][j].get_save_tile_data())
			
	var data = {
		"global": Global.get_global_data(),
		"tiles": tileData,
		"city": City.get_city_data(),
		"econ": Econ.get_econ_data(),
		"stats": Stats.stats,
		"population": UpdatePopulation.get_population_data(),
		"demand": UpdateDemand.get_demand_data(),
		"date": UpdateDate.get_date_data(),
		"waterDir": UpdateWater.waterDir,
		"achievements": AchievementObserver.get_completed_achievements(),
		"inventory": Inventory.get_inventory_data()
	}
	
	var file
	file = File.new()
	file.open(mapPath, File.WRITE)
	file.store_line(JSON.print(data, "\t"))
	file.close()
	Global.mapPath = mapPath
	
	# Update continue path
	save_continue_map()

	return [correctMapName, mapPath]


func loadData(mapPath: String):
	if not (".json" in mapPath):
		return "not a json"
	var file = File.new()
	if not file.file_exists(mapPath):
		return "file does not exist"
	file.open(mapPath, File.READ)
	var mapData = parse_json(file.get_as_text())
	file.close()
	
	
	Global.currentMap = mapPath
	Global.load_global_data(mapData.global)
	City.load_city_data(mapData.city)
	Econ.load_econ_data(mapData.econ)
	UpdatePopulation.load_population_data(mapData.population)
	UpdateDemand.load_demand_data(mapData.demand)
	UpdateDate.load_date_data(mapData.date)
	Stats.stats = mapData.stats
	UpdateWater.waterDir = mapData.waterDir
	
	AchievementObserver.load_achievements(mapData.achievements)
	Inventory.load_inventory_data(mapData.inventory)
	
	Global.tileMap.clear()
	for _x in range(Global.mapHeight):
		var row = []
		row.resize(Global.mapWidth)
		Global.tileMap.append(row)

	for tileData in mapData.tiles:
		Global.tileMap[tileData["i"]][tileData["j"]] = Tile.new(tileData)
	
	# Update continue path
	if mapPath != "res://data/default.json":
		save_continue_map()
	
	return mapData.global.mapName

func save_continue_map():
	var continuePath = "user://data/continue.json"
	print(Global.currentMap)
	var data = {
		"previous_map_path": Global.currentMap
	}
	
	var file = File.new()
	file.open(continuePath, File.WRITE)
	file.store_line(JSON.print(data, "\t"))
	file.close()
	
	return data

func get_continue_map():
	var continuePath = "user://data/continue.json"
	var file = File.new()
	file.open(continuePath, File.READ)
	var continueData = parse_json(file.get_as_text())
	file.close()

	var mapPath = continueData.previous_map_path
	return mapPath
