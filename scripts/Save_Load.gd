extends Node

func _ready():
	pass

func saveData(mapPath: String):
	var correctMapName = mapPath.trim_suffix(".json")
	correctMapName = correctMapName.trim_prefix("res://saves/")
	if not (".json" in mapPath):
		mapPath += ".json"
	print(mapPath)
	var tileData = []
			
	for i in Global.mapWidth:
		for j in Global.mapHeight:
			tileData.append(Global.tileMap[i][j].get_save_tile_data())
			
	var data = {
		"global": Global.get_global_data(),
		"tiles": tileData,
		"city": City.get_city_data(),
		"econ": Econ.get_econ_data(),
		"stats": Stats.stats,
		"date": {
			"month": UpdateDate.month,
			"year": UpdateDate.year
		}
	}
	
	var file
	file = File.new()
	file.open(mapPath, File.WRITE)
	file.store_line(JSON.print(data, "\t"))
	file.close()
	Global.mapPath = mapPath
	print(mapPath)
	return [correctMapName, mapPath]


func loadData(mapPath: String):
	if not (".json" in mapPath):
		return "not a json"
	var file = File.new()
	print(mapPath)
	if not file.file_exists(mapPath):
		return "file does not exist"
	file.open(mapPath, File.READ)
	var mapData = parse_json(file.get_as_text())
	file.close()
	
	Global.load_global_data(mapData.global)
	City.load_city_data(mapData.city)
	Econ.load_econ_data(mapData.econ)
	Stats.stats = mapData.stats
	UpdateDate.month = mapData.date.month
	UpdateDate.year = mapData.date.year
	
	Global.tileMap.clear()
	print(Stats.stats.Profit)
	for _x in range(Global.mapWidth):
		var row = []
		row.resize(Global.mapHeight)
		Global.tileMap.append(row)

	for tileData in mapData.tiles:
		Global.tileMap[tileData["i"]][tileData["j"]] = Tile.new(tileData)
	
	return mapData.global.mapName
