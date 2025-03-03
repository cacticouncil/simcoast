extends Node2D

# var mapName	# Custom name of map # File name for quick savings/loading
var copyTile # Stores tile to use when copy/pasting tiles on the map
var tickDelay = Global.TICK_DELAY #time in seconds between ticks
var numTicks = 0 #time elapsed since start
var isFastFWD = false
var current_sensor_tile
var current_road_tile
var fadedShader = preload("res://assets/shaders/faded.tres")
var invalidShader = preload("res://assets/shaders/invalid.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	initCamera()
	initSave_Exit()
	loadMapData(Global.currentMap)
	initObservers()
	
	$HUD/HBoxContainer/Money.text = "$" + Econ.comma_values(str(Econ.money))
	#$HUD/TopBar/HBoxContainer/City_Income.text = "City's Net Profit: $" + Econ.comma_values(str(Econ.city_income))
	#$HUD/TopBar/HBoxContainer/City_Tax_Rate.text = "Tax Rate: " + str(Econ.city_tax_rate * 100) + "%"
	$HUD/HBoxContainer/Population.text = str(UpdatePopulation.get_population())
	#$HUD/TopBar/HBoxContainer/Demand.text = "Residential Demand: " + str(UpdateDemand.calcResidentialDemand()) + "/10" + " Commercial Demand: " + str(UpdateDemand.calcCommercialDemand()) + "/10"
	$HUD/Date/Year.text = str(UpdateDate.year)
	$HUD/Date/Month.text = UpdateDate.Months.keys()[UpdateDate.month]
	if (Global.newGame):
		initTutorial()

func initSave_Exit():
	$Popups/SaveDialog.connect("file_selected", self, "_on_file_selected_save")
	$Popups/LoadDialog.connect("file_selected", self, "_on_file_selected_load")
# Set camera to start at middle of map, and set camera edge limits
# Width/height is number of map tiles
func initCamera():
	var mid_x = (Global.mapWidth / 2) * Global.TILE_WIDTH
	var mid_y = (Global.mapHeight / 2) * Global.TILE_HEIGHT
	
	# Use the player starting tile to calculate camera position
	$Camera2D.position.y = mid_y
	
	#Change offeset so it's the center of the actual area
	$Camera2D.offset.x = -45 #75 since toolbar is 150 so half of that
	
	$Camera2D.limit_left = (mid_x * -1) - Global.MAP_EDGE_BUFFER
	$Camera2D.limit_top = -Global.MAP_EDGE_BUFFER
	$Camera2D.limit_right = mid_x + Global.MAP_EDGE_BUFFER
	$Camera2D.limit_bottom = Global.mapHeight * Global.TILE_HEIGHT + Global.MAP_EDGE_BUFFER


func initObservers():
	#Add achievement observer
	Announcer.addObserver(get_node("/root/AchievementObserver"))
	
	#Add npc observers
	Announcer.addObserver(get_node("/root/NpcObserver"))
	NpcObserver.initializeNPCs()
	
	#Add mission observer
	var missObs = get_node("/root/MissionObserver")
	Announcer.addObserver(missObs)
	MissionObserver.createMissions()
	var missions = missObs.getMissions()
	$HUD/MissionsBG.margin_bottom = 28 + (14 * missions.size()) + (20 * (missions.size() + 1))
	$HUD/Missions/VBoxContainer/Mission1.text = missions[0]
	
	#FIXME: This line should add hover text but isn't
	""" For reference from ui_buttons.gd
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
		i.connect("mouse_entered", self, "button_hover", [i])
		i.connect("mouse_exited", self, "button_exit")
	"""
	#$HUD/Missions/VBoxContainer/Mission1.connect("mouse_entered", self, "MissionObserver.hoverMission", [0])
	get_node("HUD/Missions/VBoxContainer/Mission1").connect("mouse_entered", self, "show_mission_tip", [0])
	get_node("HUD/Missions/VBoxContainer/Mission1").connect("mouse_exited", self, "clear_mission_tip")
	if missions.size() > 1:
		$HUD/Missions/VBoxContainer/Mission2.text = missions[1]
		get_node("HUD/Missions/VBoxContainer/Mission2").connect("mouse_entered", self, "show_mission_tip", [1])
		get_node("HUD/Missions/VBoxContainer/Mission2").connect("mouse_exited", self, "clear_mission_tip")
	else:
		$HUD/Missions/VBoxContainer/Mission2.visible = false
	if missions.size() > 2:
		$HUD/Missions/VBoxContainer/Mission3.text = missions[2]
		get_node("HUD/Missions/VBoxContainer/Mission3").connect("mouse_entered", self, "show_mission_tip", [2])
		get_node("HUD/Missions/VBoxContainer/Mission3").connect("mouse_exited", self, "clear_mission_tip")
	else:
		$HUD/Missions/VBoxContainer/Mission3.visible = false
	
	#Add SFX observer
	var sfxObserver = load("res://scripts/Observers/SfxObserver.gd").new()
	Announcer.addObserver(sfxObserver)
	self.add_child(sfxObserver)
	
	# Just in case their's any action to take about this right away
	var currEvent = Event.new("Money", "Amount of money", Econ.money)
	Announcer.notify(currEvent)
	currEvent.queue_free()

func show_mission_tip(num):
	get_node("/root/CityMap/HUD/BottomBar/HoverText").text = MissionObserver.getMissionsDescriptions()[num]

func clear_mission_tip():
	get_node("/root/CityMap/HUD/BottomBar/HoverText").text = ""

# Anchor points for tile multi-select
var anchor1: Array = [null, null]
var anchor2: Array = [null, null]

# Variable for highlighting the first anchor point
var anchor1_TileCube = null

func reset_selected():
	if anchor1_TileCube:
		anchor1_TileCube.remove_yellow_tint()
	for tile in Global.selected:
		tile.cube.remove_yellow_tint()
	anchor1 = [null, null]
	anchor2 = [null, null]
	anchor1_TileCube = null
	Global.selected = []
	
func populate_selected():
	# Get the minimums and maximums
	var min_x = min(anchor1[0], anchor2[0])
	var max_x = max(anchor1[0], anchor2[0])
	var min_y = min(anchor1[1], anchor2[1])
	var max_y = max(anchor1[1], anchor2[1])
	
	# Iterate through the tile map using the min and max values
	for i in range(min_x, max_x + 1):
		for j in range(min_y, max_y + 1):
			var tile = Global.tileMap[i][j]
			Global.selected.append(tile)
			tile.cube.apply_yellow_tint()

# Handle inputs (clicks, keys)
func _unhandled_input(event):
	var actionText = get_node("HUD/BottomBar/HoverText")
	
	if event is InputEventMouseButton and event.pressed:
		actionText.text = ""
		
		var cube = $VectorMap.get_tile_at(get_global_mouse_position())
		var tile
	
		# If the click was not on a valid tile, do nothing
		if not cube:
			reset_selected()
			return
		else:
			tile = Global.tileMap[cube.i][cube.j]
			
		if Input.is_action_pressed("left_click") and Input.is_action_pressed("shift"):
			print("Shift click")
			# Reset the multi-select if it has already been defined
			if not anchor1.has(null) and not anchor2.has(null):
				reset_selected()
				
			if anchor1[0] == null: # Check if anchor1 has been defined yet
				anchor1 = [tile.i, tile.j] # If not, define it
				anchor1_TileCube = tile.cube
				anchor1_TileCube.apply_yellow_tint()
				return
			else:
				anchor2 = [tile.i, tile.j] # Define anchor2
				populate_selected() # Populate the array
				return
		
		if tile.sensor == Tile.TileSensor.TIDE || tile.sensor == Tile.TileSensor.RAIN || tile.sensor == Tile.TileSensor.WIND: 
			if Input.is_action_pressed("right_click"):
				sensor_back_to_inventory(tile.sensor)
				tile.sensor = Tile.TileSensor.NONE
		
		if Input.is_action_pressed("right_click"):
			var beach_scene = preload("res://ui/Beach/Beach.tscn")
			var beach_inst = beach_scene.instance()
			add_child(beach_inst)
			return

		reset_selected()

		# Perform action based on current tool selected
		match Global.mapTool:
			# Change Base or (if same base) raise/lower tile height
			Global.Tool.BASE_DIRT:
				if tile.get_base() != Tile.TileBase.DIRT:
					tile.clear_tile()
					tile.set_base(Tile.TileBase.DIRT)
				else:
					City.adjust_tile_height(tile)
				
			Global.Tool.BASE_ROCK:
				if tile.get_base() != Tile.TileBase.ROCK:
					tile.clear_tile()
					tile.set_base(Tile.TileBase.ROCK)
				else:
					City.adjust_tile_height(tile)

			Global.Tool.BASE_SAND:
				if tile.get_base() != Tile.TileBase.SAND:
					tile.clear_tile()
					tile.set_base(Tile.TileBase.SAND)
				else:
					City.adjust_tile_height(tile)
			
			Global.Tool.BASE_OCEAN:
				if Input.is_action_pressed("left_click"):
					Global.dragToPlaceState = true
			
			Global.Tool.BASE_SAND:
				City.adjust_tile_height(tile)
	
			# Clear and zone a tile (if it is not already of the same zone)
			Global.Tool.ZONE_SINGLE_FAMILY, Global.Tool.ZONE_MULTI_FAMILY, Global.Tool.ZONE_COM:
				if (tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE && (tile.get_base() == Tile.TileBase.DIRT || tile.get_base() == Tile.TileBase.ROCK || (tile.get_base() == Tile.TileBase.SAND && tile.baseHeight > 8))):
					var currEvent = Event.new("Added Tile", "Play SFX", 1)
					Announcer.notify(currEvent)
					currEvent.queue_free()
				if Input.is_action_pressed("left_click"):
					Global.dragToPlaceState = true
				elif Input.is_action_pressed("right_click"):
					Global.dragToRemoveState = true

			# Add/Remove Buildings
			Global.Tool.ADD_RES_BLDG:
				if tile.is_residential():
					City.adjust_building_number(tile)

			Global.Tool.ADD_COM_BLDG:
				if tile.is_commercial():
					City.adjust_building_number(tile)

			# Add/Remove People
			Global.Tool.ADD_RES_PERSON:
				if tile.is_residential():
					tile.add_people(1)

			Global.Tool.ADD_COM_PERSON:
				if tile.is_commercial() && UpdatePopulation.RESIDENTS * UpdatePopulation.BASE_EMPLOYMENT_RATE > UpdatePopulation.WORKERS:
					tile.add_people(1)

			# Water Tool
			Global.Tool.LAYER_WATER:
				if tile.get_base() != Tile.TileBase.OCEAN:
					City.adjust_tile_water(tile)
			
			Global.Tool.CLEAR_WATER:	
				tile.waterHeight = 0
				#tile.cube.update()
					
			Global.Tool.CLEAR_TILE:
				tile.clear_tile()
			
			Global.Tool.REMOVE_BEACH_ROCKS:
				Global.dragToRemoveState = true
				Weather.beachProtection -= 1
				
			Global.Tool.INF_UTILITIES_PLANT:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.UTILITIES_PLANT, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('utility plant')):
							tile.set_tile_inf(Tile.TileInf.UTILITIES_PLANT, Tile.TileZone.NONE, Global.buildingHeight, Global.buildingWidth)
							City.numUtilityPlants += 1
							var currEvent = Event.new("Added Tile", "Added Power Plant", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						elif (Econ.purchase_structure(Econ.UTILITIES_PLANT_COST)):
							tile.set_tile_inf(Tile.TileInf.UTILITIES_PLANT, Tile.TileZone.NONE, Global.buildingHeight, Global.buildingWidth)
							City.numUtilityPlants += 1
							var currEvent = Event.new("Added Tile", "Added Power Plant", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							#$PreviewSprite.remove_child(Global.hoverSprite)
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.UTILITIES_PLANT):
						actionText.text = "Cannot build here!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.UTILITIES_PLANT:
						tile.clear_tile()
						City.connectUtilities()
						City.numUtilityPlants -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.UTILITIES_PLANT:
							parentTile.clear_tile()
							City.numUtilityPlants -= 1
			
			Global.Tool.INF_SEWAGE_FACILITY:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.SEWAGE_FACILITY, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('sewage facility')):
							tile.set_tile_inf(Tile.TileInf.SEWAGE_FACILITY, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
						elif (Econ.purchase_structure(Econ.SEWAGE_FACILITY_COST)):
							tile.set_tile_inf(Tile.TileInf.SEWAGE_FACILITY, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.SEWAGE_FACILITY):
						actionText.text = "Cannot build here!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.SEWAGE_FACILITY:
						tile.clear_tile()
						City.numSewageFacilities -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.SEWAGE_FACILITY:
							parentTile.clear_tile()
							City.numSewageFacilities -= 1
			
			Global.Tool.INF_WASTE_TREATMENT:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.WASTE_TREATMENT, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('waste treatment')):
							tile.set_tile_inf(Tile.TileInf.WASTE_TREATMENT, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
						elif (Econ.purchase_structure(Econ.WASTE_TREATMENT_COST)):
							tile.set_tile_inf(Tile.TileInf.WASTE_TREATMENT, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.WASTE_TREATMENT):
						actionText.text = "Cannot build here!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.WASTE_TREATMENT:
						tile.clear_tile()
						City.numWasteTreatment -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.WASTE_TREATMENT:
							parentTile.clear_tile()
							City.numWasteTreatment -= 1
						
			Global.Tool.INF_PARK:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.get_base() == Tile.TileBase.DIRT && tile.inf != Tile.TileInf.PARK):
						if (Inventory.removeIfHave('park')):
							tile.set_tile_inf(Tile.TileInf.PARK, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							tile.zone = Tile.TileZone.PUBLIC_WORKS
							City.numParks += 1
							var currEvent = Event.new("Added Tile", "Added Park", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						elif (Econ.purchase_structure(Econ.PARK_COST)):
							tile.set_tile_inf(Tile.TileInf.PARK, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							tile.zone = Tile.TileZone.PUBLIC_WORKS
							City.numParks += 1
							var currEvent = Event.new("Added Tile", "Added Park", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.PARK):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Park must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.PARK:
						tile.clear_tile()
						City.numParks -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.PARK:
							parentTile.clear_tile()
							City.numParks -= 1
			
			Global.Tool.INF_LIBRARY:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.LIBRARY, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('library')):
							tile.set_tile_inf(Tile.TileInf.LIBRARY, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							tile.zone = Tile.TileZone.PUBLIC_WORKS
							City.numLibraries += 1
						elif (Econ.purchase_structure(Econ.LIBRARY_COST)):
							tile.set_tile_inf(Tile.TileInf.LIBRARY, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							tile.zone = Tile.TileZone.PUBLIC_WORKS
							City.numLibraries += 1
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.LIBRARY):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Libraries must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.LIBRARY:
						tile.clear_tile()
						City.numLibraries -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.LIBRARY:
							parentTile.clear_tile()
							City.numLibraries -= 1
			
			Global.Tool.INF_MUSEUM:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.MUSEUM, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('museum')):
							tile.set_tile_inf(Tile.TileInf.MUSEUM, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							tile.zone = Tile.TileZone.PUBLIC_WORKS
							City.numMuseums += 1
						elif (Econ.purchase_structure(Econ.MUSEUM_COST)):
							tile.set_tile_inf(Tile.TileInf.MUSEUM, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							tile.zone = Tile.TileZone.PUBLIC_WORKS
							City.numMuseums += 1
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.MUSEUM):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Museums must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.MUSEUM:
						tile.clear_tile()
						City.numMuseums -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.MUSEUM:
							parentTile.clear_tile()
							City.numMuseums -= 1
			
			Global.Tool.INF_FIRE_STATION:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.FIRE_STATION, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('fire station')):
							tile.set_tile_inf(Tile.TileInf.FIRE_STATION, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numFireStations += 1
						elif (Econ.purchase_structure(Econ.FIRE_STATION_COST)):
							tile.set_tile_inf(Tile.TileInf.FIRE_STATION, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numFireStations += 1
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.FIRE_STATION):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Fire stations must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.FIRE_STATION:
						tile.clear_tile()
						City.numFireStations -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.FIRE_STATION:
							parentTile.clear_tile()
							City.numFireStations -= 1
			
			Global.Tool.INF_HOSPITAL:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.HOSPITAL, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('hospital')):
							tile.set_tile_inf(Tile.TileInf.HOSPITAL, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numHospital += 1
						elif (Econ.purchase_structure(Econ.HOSPITAL_COST)):
							tile.set_tile_inf(Tile.TileInf.HOSPITAL, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numHospital += 1
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.HOSPITAL):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Hospitals must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.HOSPITAL:
						tile.clear_tile()
						City.numHospital -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.HOSPITAL:
							parentTile.clear_tile()
							City.numHospital -= 1
			
			Global.Tool.INF_POLICE_STATION:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.POLICE_STATION, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('police station')):
							tile.set_tile_inf(Tile.TileInf.POLICE_STATION, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numPoliceStations += 1
						elif (Econ.purchase_structure(Econ.POLICE_STATION_COST)):
							tile.set_tile_inf(Tile.TileInf.POLICE_STATION, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numPoliceStations += 1
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.POLICE_STATION):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Police stations must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.POLICE_STATION:
						tile.clear_tile()
						City.numPoliceStations -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.POLICE_STATION:
							parentTile.clear_tile()
							City.numPoliceStations -= 1
			
			Global.Tool.INF_SCHOOL:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.SCHOOL, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('school')):
							tile.set_tile_inf(Tile.TileInf.SCHOOL, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numSchools += 1
						elif (Econ.purchase_structure(Econ.SCHOOL_COST)):
							tile.set_tile_inf(Tile.TileInf.SCHOOL, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numSchools += 1
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.SCHOOL):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Schools must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.SCHOOL:
						tile.clear_tile()
						City.numSchools -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.SCHOOL:
							parentTile.clear_tile()
							City.numSchools -= 1
			
			Global.Tool.INF_WAVE_BREAKER:
				if Input.is_action_pressed("left_click") && tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE:
					if (tile.check_if_valid_placement(Tile.TileInf.WAVE_BREAKER, Global.buildingHeight, Global.buildingWidth)):
						if (Inventory.removeIfHave('wave breaker')):
							tile.set_tile_inf(Tile.TileInf.WAVE_BREAKER, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numWaveBreaker += 1
							Weather.beachProtection += 1
						elif (Econ.purchase_structure(Econ.WAVE_BREAKER_COST)):
							tile.set_tile_inf(Tile.TileInf.WAVE_BREAKER, Tile.TileZone.PUBLIC_WORKS, Global.buildingHeight, Global.buildingWidth)
							City.numWaveBreaker += 1
							Weather.beachProtection += 1
						else:
							actionText.text = "Not enough funds!"
						
						Global.placementState = false
						Global.mapTool = Global.Tool.NONE
						if Global.hoverSprite != null:
							Global.hoverSprite.queue_free()
							Global.hoverSprite = null
						$PreviewFade.stop()
						$HUD/ToolsMenu.deactivateButtons()
						
					elif (tile.inf == Tile.TileInf.WAVE_BREAKER):
						actionText.text = "Cannot build here!"
					else:
						actionText.text = "Schools must be built on a dirt base!"
				elif Input.is_action_pressed("right_click"):
					if tile.inf == Tile.TileInf.WAVE_BREAKER:
						tile.clear_tile()
						City.numWaveBreaker -= 1
						Weather.beachProtection -= 1
					elif tile.inf == Tile.TileInf.CHILD and tile.parent[0] > -1 and tile.parent[1] > -1:
						var parentTile = Global.tileMap[tile.parent[0]][tile.parent[1]]
						if parentTile.inf == Tile.TileInf.WAVE_BREAKER:
							parentTile.clear_tile()
							City.numWaveBreaker -= 1
							Weather.beachProtection -= 1
			
			Global.Tool.SENSOR_TIDE:
				if Input.is_action_pressed("left_click"):
					# bug workaround to not add sensors to already occupied tiles
					if (tile.inf != Tile.TileInf.BEACH_ROCKS && tile.inf != Tile.TileInf.BEACH_GRASS && tile.inf != Tile.TileInf.WAVE_BREAKER && tile.inf != Tile.TileInf.FIRE_STATION):
						if (tile.zone == Tile.TileZone.SINGLE_FAMILY || tile.zone == Tile.TileZone.COMMERCIAL || tile.zone == Tile.TileZone.MULTI_FAMILY) && !(tile.has_building()):
							$SensorNo/ColorRect.visible = true
						else:
							if (Inventory.has_building("tide gauge")):
								current_sensor_tile = tile
								$SensorChoice/ColorRect.visible = true
							else:
								print("No available sensors!")
								$SensorChoice/ColorRect2.visible = true
					else:
						$SensorNo/ColorRect.visible = true
				elif Input.is_action_pressed("right_click"):
					if tile.sensor == Tile.TileSensor.TIDE:
						tile.clear_sensor()
						SeaLevel.sensorPresent = false
						Inventory.sensors[0].increase_amount()
						Inventory.update_sensor_amount()
			Global.Tool.SENSOR_RAIN:
				if Input.is_action_pressed("left_click"):
					# bug workaround to not add sensors to already occupied tiles
					if (tile.inf != Tile.TileInf.BEACH_ROCKS && tile.inf != Tile.TileInf.BEACH_GRASS && tile.inf != Tile.TileInf.WAVE_BREAKER && tile.inf != Tile.TileInf.FIRE_STATION):
						if (tile.zone == Tile.TileZone.SINGLE_FAMILY || tile.zone == Tile.TileZone.COMMERCIAL || tile.zone == Tile.TileZone.MULTI_FAMILY) && !(tile.has_building()):
							$SensorNo/ColorRect.visible = true
						else:
							if (Inventory.has_building("rain gauge")):
								current_sensor_tile = tile
								$SensorChoice/ColorRect.visible = true
							else:
								print("No available sensors!")
								$SensorChoice/ColorRect2.visible = true
					else:
						$SensorNo/ColorRect.visible = true
				elif Input.is_action_pressed("right_click"):
					if tile.sensor == Tile.TileSensor.RAIN:
						tile.clear_sensor()
						RainLevel.sensorPresent = false
						Inventory.sensors[1].increase_amount()
						Inventory.update_sensor_amount()
			Global.Tool.SENSOR_WIND:
				if Input.is_action_pressed("left_click"):
					# bug workaround to not add sensors to already occupied tiles
					if (tile.inf != Tile.TileInf.BEACH_ROCKS && tile.inf != Tile.TileInf.BEACH_GRASS && tile.inf != Tile.TileInf.WAVE_BREAKER && tile.inf != Tile.TileInf.FIRE_STATION):
						if (tile.zone == Tile.TileZone.SINGLE_FAMILY || tile.zone == Tile.TileZone.COMMERCIAL || tile.zone == Tile.TileZone.MULTI_FAMILY) && !(tile.has_building()):
							$SensorNo/ColorRect.visible = true
						else:
							if (Inventory.has_building("wind gauge")):
								current_sensor_tile = tile
								$SensorChoice/ColorRect.visible = true
							else:
								print("No available sensors!")
								$SensorChoice/ColorRect2.visible = true
					else:
						$SensorNo/ColorRect.visible = true
				elif Input.is_action_pressed("right_click"):
					if tile.sensor == Tile.TileSensor.WIND:
						tile.clear_sensor()
						WindLevel.sensorPresent = false
						Inventory.sensors[2].increase_amount()
						Inventory.update_sensor_amount()
			Global.Tool.INF_ROAD:
				if Input.is_action_pressed("left_click"):
					Global.dragToPlaceState = true
				elif Input.is_action_pressed("right_click"):
					Global.dragToRemoveState = true
			
			Global.Tool.INF_BRIDGE:
				if Input.is_action_pressed("left_click"):
					Global.dragToPlaceState = true
				elif Input.is_action_pressed("right_click"):
					Global.dragToRemoveState = true
			
			Global.Tool.INF_BOARDWALK:
				if Input.is_action_pressed("left_click"):
					Global.dragToPlaceState = true
				elif Input.is_action_pressed("right_click"):
					Global.dragToRemoveState = true

			Global.Tool.INF_BEACH_ROCKS:
				if tile.get_base() == Tile.TileBase.SAND:
					tile.clear_tile()
					tile.inf = Tile.TileInf.BEACH_ROCKS
					if Input.is_action_pressed("right_click"):
						tile.clear_tile()
						tile.inf = Tile.TileInf.NONE

			Global.Tool.INF_BEACH_GRASS:
				if tile.get_base() == Tile.TileBase.SAND:
					tile.clear_tile()
					tile.inf = Tile.TileInf.BEACH_GRASS
					if Input.is_action_pressed("right_click"):
						tile.clear_tile()
						tile.inf = Tile.TileInf.NONE

			Global.Tool.REPAIR:
				if tile.waterHeight > 0:
					actionText.text = "Cannot repair flooded tiles. Remove water first."
				else:
					tile.tileDamage = 0
					tile.data[4] = 0

			Global.Tool.COPY_TILE:
				copyTile = tile
				actionText.text = "Tile copy saved"
				Global.mapTool = Global.Tool.NONE
				
			Global.Tool.PASTE_TILE:
				tile.paste_tile(copyTile)
				
		# Refresh graphics for cube and status bar text
		#cube.update()
		$HUD.update_tile_display(cube.i, cube.j)
	
	elif event is InputEventKey && event.pressed:
		if event.scancode == KEY_S:
			$Popups/SaveDialog.popup_centered()
		elif event.scancode == KEY_L:
			$Popups/LoadDialog.popup_centered()
		elif event.scancode == KEY_Z:
			actionText.text = "Flood and erosion damange calculated"
			City.calculate_damage()
		elif event.scancode == KEY_P:
			actionText.text = "Utilities grid recalculated"
			City.connectUtilities()
		elif event.scancode == KEY_C:
			actionText.text = "Select tile to copy"
			Global.mapTool = Global.Tool.COPY_TILE
		elif event.scancode == KEY_V:
			actionText.text = "Paste tool selected"
			Global.mapTool = Global.Tool.PASTE_TILE
		elif event.scancode == KEY_ESCAPE && get_node("/root/CityMap/AchievementMenu") == null:
			if $PauseMenu.visible:
				$PauseMenu.visible = false
				$HUD/play_button.pressed = false
				Global.isPaused = false
			else:
				$PauseMenu.visible = true
				$HUD/play_button.pressed = true
				Global.isPaused = true

	elif event is InputEventMouseButton:
		Global.dragToPlaceState = false
		Global.dragToRemoveState = false
	elif event is InputEventMouseMotion:		
		var cube = $VectorMap.get_tile_at(get_global_mouse_position())
		
		if cube:
			$HUD.update_tile_display(cube.i, cube.j)
		else:
			get_node("HUD/BottomBar/HoverText").text = ""

# Saves global variables and map data to a JSON file
func saveMapData(mapPath):
	var pathValues = SaveLoad.saveData(mapPath) 
	var correctMapName = pathValues[0]
	Global.currentMap = pathValues[1]
	get_node("HUD/BottomBar/HoverText").text = "Map file '%s'.json saved" % [correctMapName]

func loadMapData(filename):
	var mapName = SaveLoad.loadData(filename)
	$VectorMap.loadMap()
	get_node("HUD/BottomBar/HoverText").text = "Map file '%s'.json loaded" % [mapName]
	City.connectUtilities()

func _on_file_selected_load(filePath):
	if ".json" in filePath:
		loadMapData(filePath)
		initCamera()
		print("File Selected: ", filePath)
	else:
		OS.alert('File chosen is of wrong type, the game specifically uses JSON files.', 'Warning')

func _on_file_selected_save(filePath):
	print("File Selected: ", filePath)
	saveMapData(filePath)
	$HUD/BottomBar/HoverText.text = "Map Data Saved"

func _on_ExitButton_pressed():
	var popup = get_node("QuitGamePopup/PopupDialog")
	popup.popup_centered()
	#get_tree().quit()

func _on_AchievementButton_pressed():
	var AchMenu = preload("res://ui/SubMenu/AchievementMenu.tscn")
	var AchMenuInstance = AchMenu.instance()
	add_child(AchMenuInstance)
	#AchMenuInstance.setup()

func _on_ContinueButton_pressed():
	$PauseMenu.visible = false
	$HUD/play_button.pressed = false
	Global.isPaused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Global.isPaused:
		tickDelay -= delta
		if tickDelay <= 0:
			
			numTicks += 1
			#print("Ticks since start: " + str(ticksSinceStart))
			
			# print("Updating on tick: " + str(numTicks))
			update_game()
			#Graphics are now updated in the update_tiles function
			update_graphics()
			if isFastFWD:
				tickDelay = Global.TICK_DELAY * 0.5
			else:
				tickDelay = Global.TICK_DELAY

func update_game():
	#print("Updating game state on tick: " + str(numTicks))
	#UpdateWaves.update_waves()
	UpdateWeather.update_weather()
	UpdateSeaLevel.update_sea_level()
	UpdateWindLevel.update_wind_level()
	UpdateRainLevel.update_rain_level()
	
	#turning this function off until it can be fixed
	#UpdateWater.update_waves()
	#This function updates by tile and checks for active tiles
	update_tiles()
	UpdateDemand.get_demand()
	# UpdateErosion.update_erosion()
	Econ.calc_profit_rates()
	Econ.calcCityIncome()
	Econ.calculate_upkeep_costs()
	UpdateDate.update_date()
	placementState()
func update_tiles():
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			var currTile = Global.tileMap[i][j]
			#Deactivate every tile at the beginning
			currTile.isActive = false
			UpdateWater.update_water_spread_tile(currTile)
			City.calculate_damage_tile(currTile)
			#damage for storms
			if Weather.currentlyStorming == true && Weather.stormDamage == true:
				Weather.stormDamage = false
				City.calc_storm_damage_tile(currTile)
			UpdateValue.update_land_value_tile(currTile)
			UpdateHappiness.update_happiness_tile(currTile)
			UpdatePopulation.update_population_tile(currTile)
			UpdateErosion.update_erosion_tile(currTile)
			#Update the graphics for each tile
			currTile.cube.update()
			#Checks if tile is active
			currTile.check_if_active()
			#Add to active tile list if it is active or erase if not
			if currTile.isActive:
				currTile.set_active_tile()
			else:
				currTile.deactivate_tile()
	return
func placementState():
	if Global.placementState:
		var cube = $VectorMap.get_tile_at(get_global_mouse_position())
		var tile
		
		if not cube:
			return
		else:
			tile = Global.tileMap[cube.i][cube.j]
		
		if tile.check_if_valid_placement(Global.infType, Global.buildingHeight, Global.buildingWidth):
			if Global.hoverSprite != null:
				Global.hoverSprite.queue_free()
				Global.hoverSprite = null
			# If the click was not on a valid tile, do nothing
			
			Global.hoverSprite = null
			var x = (cube.i * (Global.TILE_WIDTH / 2.0)) + (cube.j * (-Global.TILE_WIDTH / 2.0))
			var y = (cube.i * (Global.TILE_HEIGHT / 2.0)) + (cube.j * (Global.TILE_HEIGHT / 2.0))
			var h = tile.get_base_height()
			
			Global.hoverSprite = Sprite.new()
			Global.hoverSprite.texture = load(Global.hoverImage)
			Global.hoverSprite.position = Vector2(x, y - h - 32 * (Global.buildingHeight - 1))
			#TODO: Ideally we shouldn't need scale and the sprites are the correct size, account for this when need be
			Global.hoverSprite.scale = Vector2(Global.buildingHeight, Global.buildingHeight)
			Global.hoverSprite.material = ShaderMaterial.new()
			Global.hoverSprite.z_index = (cube.i + cube.j) * 10 - (Global.buildingHeight - 1)
			
			Global.hoverSprite.material.shader = fadedShader
			
			$PreviewSprite.add_child(Global.hoverSprite)
	elif Global.dragToPlaceState:
		
		var cube = $VectorMap.get_tile_at(get_global_mouse_position())
		var tile
		
		if not cube:
			return
		else:
			tile = Global.tileMap[cube.i][cube.j]
		
		if (tile.get_zone() == Tile.TileZone.NONE && tile.inf == Tile.TileInf.NONE):
			if (tile.get_base() == Tile.TileBase.DIRT || tile.get_base() == Tile.TileBase.ROCK):
				if (Global.mapTool == Global.Tool.INF_ROAD):
					if (Inventory.removeIfHave('road')):
						tile.clear_tile()
						tile.inf = Tile.TileInf.ROAD
						City.connectRoads(tile)
						City.connectUtilities()
						City.numRoads += 1
						var currEvent = Event.new("Added Tile", "Added Road", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
					elif (Econ.purchase_structure(Econ.ROAD_COST)):
						tile.clear_tile()
						tile.inf = Tile.TileInf.ROAD
						City.connectRoads(tile)
						City.connectUtilities()
						City.numRoads += 1
						var currEvent = Event.new("Added Tile", "Added Road", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
				elif (Global.mapTool == Global.Tool.ZONE_SINGLE_FAMILY):
					if tile.get_zone() != Tile.TileZone.SINGLE_FAMILY:
						var currEvent = Event.new("Added Tile", "Added Residential Area", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
						if tile.has_utilities():
							currEvent = Event.new("Added Powered Tile", "Added Residential Area", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						tile.clear_tile()
						tile.set_zone(Tile.TileZone.SINGLE_FAMILY)
				elif (Global.mapTool == Global.Tool.ZONE_MULTI_FAMILY):
					if tile.get_zone() != Tile.TileZone.MULTI_FAMILY:
						var currEvent = Event.new("Added Tile", "Added Residential Area", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
						if tile.has_utilities():
							currEvent = Event.new("Added Powered Tile", "Added Residential Area", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						tile.clear_tile()
						tile.set_zone(Tile.TileZone.MULTI_FAMILY)
				elif (Global.mapTool == Global.Tool.ZONE_COM):
					if !tile.is_commercial():
						var currEvent = Event.new("Added Tile", "Added Commercial Area", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
						if tile.has_utilities():
							currEvent = Event.new("Added Powered Tile", "Added Commercial Area", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						tile.clear_tile()
						tile.set_zone(Tile.TileZone.COMMERCIAL)
				elif (Global.mapTool == Global.Tool.BASE_OCEAN):
					if (Econ.purchase_structure(Econ.WATER_COST)):
						tile.clear_tile()
						tile.set_base(Tile.TileBase.OCEAN)
						tile.set_base_height(Global.oceanHeight)
						tile.set_water_height(0)
			elif (tile.get_base() == Tile.TileBase.OCEAN):
				if (Global.mapTool == Global.Tool.INF_BRIDGE):
					if (Inventory.removeIfHave('bridge')):
						tile.clear_tile()
						tile.inf = Tile.TileInf.BRIDGE
						City.connectRoads(tile)
						City.connectUtilities()
						City.numBridges += 1
					elif (Econ.purchase_structure(Econ.BRIDGE_COST)):
						tile.clear_tile()
						tile.inf = Tile.TileInf.BRIDGE
						City.connectRoads(tile)
						City.connectUtilities()
						City.numBridges += 1
			elif (tile.get_base() == Tile.TileBase.SAND):
				if (Global.mapTool == Global.Tool.INF_BOARDWALK):
					if (Inventory.removeIfHave('boardwalk')):
						tile.clear_tile()
						tile.inf = Tile.TileInf.BOARDWALK
						City.connectRoads(tile)
						City.connectUtilities()
						City.numBoardwalks += 1
					elif (Econ.purchase_structure(Econ.BOARDWALK_COST)):
						tile.clear_tile()
						tile.inf = Tile.TileInf.BOARDWALK
						City.connectRoads(tile)
						City.connectUtilities()
						City.numBoardwalks += 1
				elif (Global.mapTool == Global.Tool.ZONE_SINGLE_FAMILY):
					if tile.get_zone() != Tile.TileZone.SINGLE_FAMILY && tile.baseHeight > 8:
						var currEvent = Event.new("Added Tile", "Added Resedential Area", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
						if tile.has_utilities():
							currEvent = Event.new("Added Powered Tile", "Added Resedential Area", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						tile.clear_tile()
						tile.set_zone(Tile.TileZone.SINGLE_FAMILY)
						tile.on_beach = true
				elif (Global.mapTool == Global.Tool.ZONE_MULTI_FAMILY):
					if tile.get_zone() != Tile.TileZone.MULTI_FAMILY && tile.baseHeight > 8:
						var currEvent = Event.new("Added Tile", "Added Resedential Area", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
						if tile.has_utilities():
							currEvent = Event.new("Added Powered Tile", "Added Resedential Area", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						tile.clear_tile()
						tile.set_zone(Tile.TileZone.MULTI_FAMILY)
						tile.on_beach = true
				elif (Global.mapTool == Global.Tool.ZONE_COM):
					if !tile.is_commercial() && tile.baseHeight > 8:
						var currEvent = Event.new("Added Tile", "Added Commercial Area", 1)
						Announcer.notify(currEvent)
						currEvent.queue_free()
						if tile.has_utilities():
							currEvent = Event.new("Added Powered Tile", "Added Commercial Area", 1)
							Announcer.notify(currEvent)
							currEvent.queue_free()
						tile.clear_tile()
						tile.set_zone(Tile.TileZone.COMMERCIAL)
						tile.on_beach = true
				
						Announcer.notify(Event.new("Added Tile", "Added Bridge", 1))
		#if on damaged road tile, left click to repair
		elif Global.mapTool == Global.Tool.INF_ROAD && tile.inf == Tile.TileInf.ROAD && tile.tileDamage > 0:
			Global.dragToPlaceState = false
			current_road_tile = tile
			if tile.tileDamage == 0.25:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This road has light damage.\nRepair for $15?"
			elif tile.tileDamage == 0.50:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This road has medium damage.\nRepair for $30?"
			elif tile.tileDamage == 0.75:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This road has heavy damage.\nRepair for $60?"
			$RoadRepair.visible = true
		
		elif Global.mapTool == Global.Tool.INF_BRIDGE && tile.inf == Tile.TileInf.BRIDGE && tile.tileDamage > 0:
			Global.dragToPlaceState = false
			current_road_tile = tile
			if tile.tileDamage == 0.25:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This bridge has light damage.\nRepair for $30?"
			elif tile.tileDamage == 0.50:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This bridge has medium damage.\nRepair for $60?"
			elif tile.tileDamage == 0.75:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This bridge has heavy damage.\nRepair for $120?"
			$RoadRepair.visible = true
			
		elif Global.mapTool == Global.Tool.INF_BOARDWALK && tile.inf == Tile.TileInf.BOARDWALK && tile.tileDamage > 0:
			Global.dragToPlaceState = false
			current_road_tile = tile
			if tile.tileDamage == 0.25:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This boardwalk has light damage.\nRepair for $30?"
			elif tile.tileDamage == 0.50:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This boardwalk has medium damage.\nRepair for $60?"
			elif tile.tileDamage == 0.75:
				$RoadRepair/ColorRect/ChoiceBox/ChoicePrompt.text = "This boardwalk has heavy damage.\nRepair for $120?"
			$RoadRepair.visible = true
			
	elif Global.dragToRemoveState:
		
		var cube = $VectorMap.get_tile_at(get_global_mouse_position())
		var tile
		
		if not cube:
			return
		else:
			tile = Global.tileMap[cube.i][cube.j]
			
		if Global.mapTool == Global.Tool.INF_ROAD && tile.inf == Tile.TileInf.ROAD:
			tile.clear_tile()
			City.connectRoads(tile)
			City.connectUtilities()
			City.numRoads -= 1
		elif Global.mapTool == Global.Tool.INF_BRIDGE && tile.inf == Tile.TileInf.BRIDGE:
			tile.clear_tile()
			tile.bridgeHeight = 0
			City.disconnectBridges(tile)
			City.connectRoads(tile)
			City.connectUtilities()
			City.numBridges -= 1
		elif Global.mapTool == Global.Tool.INF_BOARDWALK && tile.inf == Tile.TileInf.BOARDWALK:
			tile.clear_tile()
			City.connectRoads(tile)
			City.connectUtilities()
			City.numBoardwalks -= 1
		elif (Global.mapTool == Global.Tool.ZONE_SINGLE_FAMILY && tile.zone == Tile.TileZone.SINGLE_FAMILY) || (Global.mapTool == Global.Tool.ZONE_MULTI_FAMILY && tile.zone == Tile.TileZone.MULTI_FAMILY) || (Global.mapTool == Global.Tool.ZONE_COM && tile.zone == Tile.TileZone.COMMERCIAL):
			tile.clear_tile()
		elif Global.mapTool == Global.Tool.REMOVE_BEACH_ROCKS && (tile.inf == Tile.TileInf.BEACH_ROCKS || tile.inf == Tile.TileInf.BEACH_GRASS):
			if (Inventory.removeIfHave('remove rocks')):
				tile.clear_tile()
			elif (Econ.purchase_structure(Econ.REMOVE_BEACH_ROCK)):
				tile.clear_tile()



func update_graphics():
	#print("Updating graphics on tick: " + str(numTicks))
	UpdateGraphics.update_graphics()

func _on_play_button_toggled(button_pressed:bool):
	Global.isPaused = button_pressed
	if Global.isPaused:
		$PauseMenu.visible = true

func _on_fastfwd_button_toggled(button_pressed:bool):
	isFastFWD = button_pressed

func _on_DashboardButton_pressed():
	$HUD/TopBarBG/DashboardSelected.visible = true
	$HUD/TopBarBG/AchievementSelected.visible = false
	$HUD/TopBarBG/StoreSelected.visible = false
	var Dashboard = preload("res://ui/Dashboard/Dashboard.tscn")
	var DashboardInstance = Dashboard.instance()
	add_child(DashboardInstance)
	Announcer.notify(Event.new("Dashboard", "Entered", 2))

func _on_UIAchievementButton_pressed():
	$HUD/TopBarBG/DashboardSelected.visible = false
	$HUD/TopBarBG/AchievementSelected.visible = true
	$HUD/TopBarBG/StoreSelected.visible = false
	var AchMenu = preload("res://ui/SubMenu/AchievementMenu.tscn")
	var AchMenuInstance = AchMenu.instance()
	add_child(AchMenuInstance)

func _on_StoreButton_pressed():
	var store = preload("res://ui/hud/NPC_Interactions/Shop.tscn")
	var store_instance = store.instance()
	add_child(store_instance)
	Announcer.notify(Event.new("Store", "Entered", 1))

func _on_DashboardButton_mouse_entered():
	$HUD/TopBarBG/DashboardHover.visible = true

func _on_UIAchievementButton_mouse_entered():
	$HUD/TopBarBG/AchievementHover.visible = true

func _on_StoreButton_mouse_entered():
	$HUD/TopBarBG/StoreHover.visible = true
func _on_OfficeButton_mouse_entered():
	$HUD/TopBarBG/OfficeHover.visible = true
func _on_DashboardButton_mouse_exited():
	$HUD/TopBarBG/DashboardHover.visible = false

func _on_UIAchievementButton_mouse_exited():
	$HUD/TopBarBG/AchievementHover.visible = false

func _on_StoreButton_mouse_exited():
	$HUD/TopBarBG/StoreHover.visible = false
func _on_OfficeButton_mouse_exited():
	$HUD/TopBarBG/OfficeHover.visible = false
# sensor options -> yes, no, or ask for help
# yes adds sensor to tile
func _on_YesButton_pressed():

	$SensorChoice/ColorRect.visible = false
	match Global.mapTool:
		Global.Tool.SENSOR_TIDE:
			# different colors to represent if sensor is active or not
			if (current_sensor_tile.sensor != Tile.TileSensor.TIDE):
				sensor_back_to_inventory(current_sensor_tile.sensor)
					
				if (current_sensor_tile.get_base() == Tile.TileBase.OCEAN):
					current_sensor_tile.sensor_active = true
					SeaLevel.sensorPresent = true
				else:
					current_sensor_tile.sensor_active = false
				#current_sensor_tile.clear_tile()
				current_sensor_tile.sensor = Tile.TileSensor.TIDE
				Inventory.remove_sensor("tide gauge")
				get_node("/root/CityMap/HUD/ToolsMenu").removeSensorButton("Tide Gauge")
			elif (current_sensor_tile.sensor == Tile.TileSensor.TIDE):
				print("Sensor already here!")
			else:
				print("Different sensor here")
		Global.Tool.SENSOR_RAIN:
			if (current_sensor_tile.sensor != Tile.TileSensor.RAIN):
				sensor_back_to_inventory(current_sensor_tile.sensor)
				# different colors to represent if sensor is active or not
				if (current_sensor_tile.get_base() == Tile.TileBase.DIRT):
					current_sensor_tile.sensor_active = true
					RainLevel.sensorPresent = true
				else:
					current_sensor_tile.sensor_active = false
				#current_sensor_tile.clear_tile()
				current_sensor_tile.sensor = Tile.TileSensor.RAIN
				Inventory.remove_sensor("rain gauge")
				get_node("/root/CityMap/HUD/ToolsMenu").removeSensorButton("Rain Gauge")
			elif (current_sensor_tile.sensor == Tile.TileSensor.RAIN):
				print("Sensor already here!")
			else:
				print("Different sensor here")
		Global.Tool.SENSOR_WIND:
			if (current_sensor_tile.sensor != Tile.TileSensor.WIND):
				sensor_back_to_inventory(current_sensor_tile.sensor)
				# different colors to represent if sensor is active or not
				if (current_sensor_tile.get_base() == Tile.TileBase.SAND):
					current_sensor_tile.sensor_active = true
					WindLevel.sensorPresent = true
				else:
					current_sensor_tile.sensor_active = false
				#current_sensor_tile.clear_tile()
				current_sensor_tile.sensor = Tile.TileSensor.WIND
				Inventory.remove_sensor("wind gauge")
				get_node("/root/CityMap/HUD/ToolsMenu").removeSensorButton("Wind Gauge")
			elif (current_sensor_tile.sensor == Tile.TileSensor.WIND):
				print("Sensor already here!")
			else:
				print("Different sensor here")

func sensor_back_to_inventory(s):
	if s == Tile.TileSensor.RAIN:
		var sensor_name = "Rain Gauge"
		var button = [sensor_name.to_lower(), "res://assets/buttons/" + sensor_name.to_lower(), sensor_name]
		get_node("/root/CityMap/HUD/ToolsMenu").addSensorButton(button)
		RainLevel.sensorPresent = false
		Inventory.sensors[1].increase_amount()
		Inventory.update_sensor_amount()
	elif s == Tile.TileSensor.TIDE:
		var sensor_name = "Tide Gauge"
		var button = [sensor_name.to_lower(), "res://assets/buttons/" + sensor_name.to_lower(), sensor_name]
		get_node("/root/CityMap/HUD/ToolsMenu").addSensorButton(button)
		SeaLevel.sensorPresent = false
		Inventory.sensors[0].increase_amount()
		Inventory.update_sensor_amount()
	elif s == Tile.TileSensor.WIND:
		var sensor_name = "Wind Gauge"
		var button = [sensor_name.to_lower(), "res://assets/buttons/" + sensor_name.to_lower(), sensor_name]
		get_node("/root/CityMap/HUD/ToolsMenu").addSensorButton(button)
		WindLevel.sensorPresent = false
		Inventory.sensors[2].increase_amount()
		Inventory.update_sensor_amount()

#does not add sensor to tile
func _on_NoButton_pressed():
	$SensorChoice/ColorRect.visible = false

# help display
func _on_HelpButton_pressed():
	#$SensorChoice/ColorRect/ChoiceBox/HelpButton/ColorRect.visible = true
	match Global.mapTool:
		Global.Tool.SENSOR_TIDE:
			$SensorChoice/ColorRect/ChoiceBox/HelpButton/ColorRect/RichTextLabel.text = "The Professor recommends putting tide sensors in the ocean, near the shore, where they will be most effective."
		Global.Tool.SENSOR_RAIN:
			$SensorChoice/ColorRect/ChoiceBox/HelpButton/ColorRect/RichTextLabel.text = "The Professor recommends putting rain sensors inland, near tall buildings, where they will be most effective."
		Global.Tool.SENSOR_WIND:
			$SensorChoice/ColorRect/ChoiceBox/HelpButton/ColorRect/RichTextLabel.text = "The Professor recommends putting wind sensors near the beach, where they will be most effective."
	

func _on_CloseHelpButton_pressed():
	$SensorChoice/ColorRect/ChoiceBox/HelpButton/ColorRect.visible = false


# bug fix for no sensors on buildings
func _on_CloseNoButton_pressed():
	$SensorNo/ColorRect.visible = false # Replace with function body.


func _on_OkButton_pressed():
	$SensorChoice/ColorRect2.visible = false # Replace with function body.
	
func initTutorial():
	var tutorial = preload("res://ui/hud/NPC_Interactions/Tutorial.tscn")
	var TutorialInstance = tutorial.instance()
	add_child(TutorialInstance)


func _on_RoadRepairYesButton_pressed():
	var tile = current_road_tile
	
	if tile.inf == Tile.TileInf.ROAD:
		if tile.tileDamage == 0.25:
			if (Econ.purchase_structure(Econ.ROAD_REPAIR_L_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Road", 1))
			else:
				$RoadRepairError.visible = true
		elif tile.tileDamage == 0.5:
			if (Econ.purchase_structure(Econ.ROAD_REPAIR_M_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Road", 1))
			else:
				$RoadRepairError.visible = true
		elif tile.tileDamage == 0.75:
			if (Econ.purchase_structure(Econ.ROAD_REPAIR_H_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Road", 1))
			else:
				$RoadRepairError.visible = true
	elif tile.inf == Tile.TileInf.BRIDGE:
		if tile.tileDamage == 0.25:
			if (Econ.purchase_structure(Econ.BRIDGE_REPAIR_L_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Bridge", 1))
			else:
				$RoadRepairError.visible = true
		elif tile.tileDamage == 0.5:
			if (Econ.purchase_structure(Econ.BRIDGE_REPAIR_M_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Bridge", 1))
			else:
				$RoadRepairError.visible = true
		elif tile.tileDamage == 0.75:
			if (Econ.purchase_structure(Econ.BRIDGE_REPAIR_H_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Bridge", 1))
			else:
				$RoadRepairError.visible = true
	elif tile.inf == Tile.TileInf.BOARDWALK:
		if tile.tileDamage == 0.25:
			if (Econ.purchase_structure(Econ.BOARDWALK_REPAIR_L_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Boardwalk", 1))
			else:
				$RoadRepairError.visible = true
		elif tile.tileDamage == 0.5:
			if (Econ.purchase_structure(Econ.BOARDWALK_REPAIR_M_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Boardwalk", 1))
			else:
				$RoadRepairError.visible = true
		elif tile.tileDamage == 0.75:
			if (Econ.purchase_structure(Econ.BOARDWALK_REPAIR_H_COST)):
				tile.tileDamage = 0
				tile.wearAndTear = 0
				Announcer.notify(Event.new("Repaired Tile", "Repaired Boardwalk", 1))
			else:
				$RoadRepairError.visible = true
	$RoadRepair.visible = false


func _on_RoadRepairNoButton_pressed():
	$RoadRepair.visible = false


func _on_RoadRepairOKButton_pressed():
	$RoadRepairError.visible = false


func _on_OfficeButton_pressed():
	var office = preload("res://ui/hud/NPC_Interactions/Office.tscn")
	var OfficeInstance = office.instance()
	add_child(OfficeInstance)
