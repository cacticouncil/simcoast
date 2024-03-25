extends ScrollContainer

var group = preload("res://toolbar_button_group.tres")

var mapName
var mapPath
var savePopup
var loadPopup

var toolbarSectionScene = preload("res://ui/hud/Toolbar/ToolbarSection.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#Removes the scroll bar
	self.get_v_scrollbar().rect_scale.x = 0
	
	#Info for each button, button name will be the first part + '_button'.
	#Second parameter is for images, utilizes the fact that all file names end in second part + '_normal' or '_active' or '_hover'
	var infrastructureButtons = [
		["road", "res://assets/buttons/road", "Road/Power Tile"], 
		["bridge", "res://assets/buttons/bridge", "Bridge/Power Tile"],
		["boardwalk", "res://assets/buttons/boardwalk", "Boardwalk/Power Tile"],
		["water", "res://assets/buttons/water", "Lowers tile to water level"]
	]
	var infrastructureSection = toolbarSectionScene.instance()
	#Creates a section of the buttons and takes in the list of ones to add
	infrastructureSection.add_button("Infrastructure", infrastructureButtons)
	$VBoxContainer.add_child(infrastructureSection)
	infrastructureSection.set_bg(infrastructureSection.rect_size, Color("526e7584"))
	
	#Rest of sections all act like above one.
	var zoneButtons = [
		["house", "res://assets/buttons/lt_res_zone", "House Zone"], 
		["apartment", "res://assets/buttons/hv_res_zone", "Apartment Zone"], 
		["shop", "res://assets/buttons/lt_com_zone", "Shop Zone"]
	]
	var zoneSection = toolbarSectionScene.instance()
	zoneSection.add_button("Zones", zoneButtons)
	$VBoxContainer.add_child(zoneSection)
	zoneSection.set_bg(zoneSection.rect_size, Color("e03c3c3c"))
	
	var industrialButtons = [
		["utility plant", "res://assets/buttons/power_plant", "Utility Plant"], 
		["sewage facility", "res://assets/buttons/sewage", "Sewage Facility"], 
		["waste treatment", "res://assets/buttons/wasteTreatment", "Waste Treatment"]
	]
	var industrialSection = toolbarSectionScene.instance()
	industrialSection.add_button("Industrial", industrialButtons)
	$VBoxContainer.add_child(industrialSection)
	industrialSection.set_bg(industrialSection.rect_size, Color("526e7584"))
	
	var emergencyServiceButtons = [
		["fire station", "res://assets/buttons/fireStation", "Fire Station"], 
		["hospital", "res://assets/buttons/hospital", "Hospital"], 
		["police station", "res://assets/buttons/policeStation", "Police Station"]
	]
	var emergencyServiceSection = toolbarSectionScene.instance()
	emergencyServiceSection.add_button("Emergency Services", emergencyServiceButtons)
	$VBoxContainer.add_child(emergencyServiceSection)
	emergencyServiceSection.set_bg(emergencyServiceSection.rect_size, Color("e03c3c3c"))
	
	var publicServiceButtons = [
		["park", "res://assets/buttons/park", "Park"], 
		["library", "res://assets/buttons/library", "Library"], 
		["museum", "res://assets/buttons/museum", "Museum"],
		["school", "res://assets/buttons/school", "School"]
	]
	var publicServiceSection = toolbarSectionScene.instance()
	publicServiceSection.add_button("Public Services", publicServiceButtons)
	$VBoxContainer.add_child(publicServiceSection)
	publicServiceSection.set_bg(publicServiceSection.rect_size, Color("526e7584"))
	
	var beachButtons = [
		["wavebreaker", "res://assets/buttons/wave_breaker", "Wavebreaker"], 
		["close beach", "res://assets/buttons/close_beach", "Close Beach"],
		["remove rocks", "res://assets/buttons/remove_beach_rocks", "Remove Beach Rocks"]
	]
	var beachSection = toolbarSectionScene.instance()
	#Creates a section of the buttons and takes in the list of ones to add
	beachSection.add_button("Beach", beachButtons)
	$VBoxContainer.add_child(beachSection)
	beachSection.set_bg(beachSection.rect_size, Color("e03c3c3c"))
	
	var sensorButtons = [
		["tide sensor", "res://assets/buttons/tide_sensor", "Tide Gauge"], 
		["rain sensor", "res://assets/buttons/rain_gauge", "Rain Gauge"]
	]
	var sensorSection = toolbarSectionScene.instance()
	sensorSection.add_button("Sensors", sensorButtons)
	$VBoxContainer.add_child(sensorSection)
	sensorSection.set_bg(sensorSection.rect_size, Color("526e7584"))
	
	#Once we create all the buttons, we want to add the functionality to each of them
	for i in group.get_buttons():
		#Handles button presses
		i.connect("pressed", self, "button_pressed")
		#Handles adding hover text to bottom bar
		i.connect("mouse_entered", self, "button_hover", [i])
		#Handles removing hover text
		i.connect("mouse_exited", self, "button_exit")
	#Updates the little icon that indicates how much of each item we have
	updateAmounts()
	

func button_exit():
	get_node("../BottomBar/HoverText").text = ""

# Displays detailed tool information when hovering
func button_hover(button):
	var toolInfo = get_node("../BottomBar/HoverText")

	#Based on button name, add respective hover text
	match button.get_name():
		'increase_tax_button':
			toolInfo.text = "Increase city tax rate by 1%"
		'decrease_tax_button':
			toolInfo.text = "Decrease city tax rate by 1%"
		'dirt_button':
			toolInfo.text = "Replace base tile with dirt / Raise dirt base tile height   (Right Click: Lower dirt base tile height)"
		'rock_button':
			toolInfo.text = "Replace base tile with rock / Raise rock base tile height   (Right Click: Lower rock base tile height)"
		'sand_button':
			toolInfo.text = "Replace base tile with sand / Raise and base tile height   (Right Click: Lower sand base tile height)"
		'ocean_button':
			toolInfo.text = "Replace base tile with ocean"
		'water_button':
			toolInfo.text = "Turns tile to water"
		'house_button':
			toolInfo.text = "Light Residential Zone   (Right Click: Remove zoning)"
		'apartment_button':
			toolInfo.text = "Heavy Residential Zone   (Right Click: Remove zoning)"
		'add_house_button':
			toolInfo.text = "Add building to residential zone   (Right Click: Remove building)"
		'add_resident_button':
			toolInfo.text = "Add resident to residential zone   (Right Click: Remove person)"
		'shop_button':
			toolInfo.text = "Light Commercial Zone   (Right Click: Remove zoning)"
		'add_building_button':
			toolInfo.text = "Add building to commercial zone   (Right Click: Remove building)"
		'add_employee_button':
			toolInfo.text = "Add employee to commercial zone   (Right Click: Remove employee)"
		'fire station_button':
			toolInfo.text = "Build Fire Station   (Right Click: Remove Fire Station)"
		'hospital_button':
			toolInfo.text = "Build Hospital   (Right Click: Remove Hospital)"
		'police station_button':
			toolInfo.text = "Build Police Station   (Right Click: Remove Police Station)"
		'utility plant_button':
			toolInfo.text = "Build Utilities Plant"
		'sewage facility_button':
			toolInfo.text = "Build Sewage Facility"
		'waste treatment_button':
			toolInfo.text = "Build Waste Treatment Facility"
		'road_button':
			toolInfo.text = "Build infrastructure (road/power/water) tile   (Right Click: Remove infrastructure)"
		'bridge_button':
			toolInfo.text = "Build infrastructure tile over water   (Right Click: Remove infrastructure)"
		'park_button':
			toolInfo.text = "Build Park   (Right Click: Remove park)"	
		'library_button':
			toolInfo.text = "Build Library   (Right Click: Remove Library)"
		'museum_button':
			toolInfo.text = "Build Museum   (Right Click: Remove Museum)"
		'school_button':
			toolInfo.text = "Build School   (Right Click: Remove Museum)"
		'beach_rocks_button':
			toolInfo.text = "Add beach rocks to sand tile   (Right Click: Remove rocks)"
		'beach_grass_button':
			toolInfo.text = "Add beach grass to sand tile   (Right Click: Remove rocks)"			
		'clear_button':
			toolInfo.text = "Clear tile"
		'repair_button':
			toolInfo.text = "Repair damaged tiles"
		'add_water_button':
			toolInfo.text = "Increase tile water height  (Right Click: Lower tile water height)"
		'clear_water_button':
			toolInfo.text = "Remove all water from tile"
		'raise_ocean_button':
			toolInfo.text = "Increase the height of the ocean"
		'lower_ocean_button':
			toolInfo.text = "Decrease the height of the ocean"
		'damage_button':
			toolInfo.text = "Evaluate current flooding and erosion damage from ocean"
		'satisfaction_button':
			toolInfo.text = "Evaluate current resident city satisfaction"
		'rotate_camera_button':
			toolInfo.text = "Rotate camera 1/4 turn"
		'quicksave_button':
			toolInfo.text = "Quicksave current map"

func button_pressed():
	Global.placementState = false
	Global.hoverImage = ""
	Global.infType = Tile.TileInf.NONE
	Global.buildingHeight = 1
	Global.buildingWidth = 1
	if Global.hoverSprite != null:
		Global.hoverSprite.queue_free()
		Global.hoverSprite = null
	#Adds function for when button is pressed.
	#Most just set the map tool, code for handling what to do when map tool used is in start_map.gd
	match group.get_pressed_button().get_name():
		#TODO: some of these buttons are depreciated. Thought the code could be useful at some point
		#but they should be removed from here eventually.
		'increase_tax_button':
			Econ.adjust_tax_rate(0.01)
		'decrease_tax_button':
			Econ.adjust_tax_rate(-0.01)
		'dirt_button':
			Global.mapTool = Global.Tool.BASE_DIRT
		'rock_button':
			Global.mapTool = Global.Tool.BASE_ROCK
		'sand_button':
			Global.mapTool = Global.Tool.BASE_SAND
		'ocean_button':
			Global.mapTool = Global.Tool.BASE_OCEAN
		'water_button':
			Global.mapTool = Global.Tool.BASE_OCEAN
		'house_button':
			Global.mapTool = Global.Tool.ZONE_SINGLE_FAMILY
		'apartment_button':
			Global.mapTool = Global.Tool.ZONE_MULTI_FAMILY
		'add_house_button':
			Global.mapTool = Global.Tool.ADD_RES_BLDG
		'add_resident_button':
			Global.mapTool = Global.Tool.ADD_RES_PERSON
		'shop_button':
			Global.mapTool = Global.Tool.ZONE_COM
		'add_building_button':
			Global.mapTool = Global.Tool.ADD_COM_BLDG
		'add_employee_button':
			Global.mapTool = Global.Tool.ADD_COM_PERSON
		'fire station_button':
			Global.mapTool = Global.Tool.INF_FIRE_STATION
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/Firehouse.png"
			Global.infType = Tile.TileInf.FIRE_STATION
			Global.buildingHeight = 2
			Global.buildingWidth = 2
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'hospital_button':
			Global.mapTool = Global.Tool.INF_HOSPITAL
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/Hospital.png"
			Global.infType = Tile.TileInf.HOSPITAL
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'police station_button':
			Global.mapTool = Global.Tool.INF_POLICE_STATION
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/PoliceStation.png"
			Global.infType = Tile.TileInf.POLICE_STATION
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'utility plant_button':
			Global.mapTool = Global.Tool.INF_UTILITIES_PLANT
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/UtilityPlant.png"
			Global.infType = Tile.TileInf.UTILITIES_PLANT
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'sewage facility_button':
			Global.mapTool = Global.Tool.INF_SEWAGE_FACILITY
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/SewageFacility.png"
			Global.infType = Tile.TileInf.SEWAGE_FACILITY
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'waste treatment_button':
			Global.mapTool = Global.Tool.INF_WASTE_TREATMENT
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/WasteTreatment.png"
			Global.infType = Tile.TileInf.WASTE_TREATMENT
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'park_button':
			Global.mapTool = Global.Tool.INF_PARK
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/Park.png"
			Global.infType = Tile.TileInf.PARK
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'library_button':
			Global.mapTool = Global.Tool.INF_LIBRARY
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/Library.png"
			Global.infType = Tile.TileInf.LIBRARY
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'museum_button':
			Global.mapTool = Global.Tool.INF_MUSEUM
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/Museum.png"
			Global.infType = Tile.TileInf.MUSEUM
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'school_button':
			Global.mapTool = Global.Tool.INF_SCHOOL
			Global.placementState = true
			Global.hoverImage = "res://assets/building_assets/2d Assets/School.png"
			Global.infType = Tile.TileInf.SCHOOL
			Global.buildingHeight = 1
			Global.buildingWidth = 1
			get_node("/root/CityMap/PreviewFade").play("Fade")
		'road_button':
			Global.mapTool = Global.Tool.INF_ROAD
		'bridge_button':
			Global.mapTool = Global.Tool.INF_BRIDGE
		'boardwalk_button':
			Global.mapTool = Global.Tool.INF_BOARDWALK
		'beach_rocks_button':
			Global.mapTool = Global.Tool.INF_BEACH_ROCKS
		'beach_grass_button':
			Global.mapTool = Global.Tool.INF_BEACH_GRASS
		'clear_button':
			Global.mapTool = Global.Tool.CLEAR_TILE
		'repair_button':
			Global.mapTool = Global.Tool.REPAIR
		'add_water_button':
			Global.mapTool = Global.Tool.LAYER_WATER
		'clear_water_button':
			Global.mapTool = Global.Tool.CLEAR_WATER
		'close beach_button':
			Global.mapTool = Global.Tool.NONE
			if !Global.closeBeach && !Global.beginBeachEvacuation && !Global.stayEvacuated && !Global.moveBackIn:
				Global.closeBeach = true
			#$VBoxContainer.get_child(6).get_child(1).get_child(2).get_child(1).text = "Open Beach"
			deactivateButtons()
			
		'remove rocks_button':
			Global.mapTool = Global.Tool.REMOVE_BEACH_ROCKS
		'tide sensor_button':
			Global.mapTool = Global.Tool.SENSOR_TIDE
		'rain sensor_button':
			Global.mapTool = Global.Tool.SENSOR_RAIN
		'raise_ocean_button':
			Global.mapTool = Global.Tool.NONE
			if Global.oceanHeight < Global.MAX_HEIGHT:
				Global.oceanHeight += 1
				City.updateOceanHeight(1)
				get_node("../BottomBar/HoverText").text = "Ocean height raised to %s" % [Global.oceanHeight]
		
		'lower_ocean_button':
			Global.mapTool = Global.Tool.NONE
			if Global.oceanHeight > 0:
				Global.oceanHeight -= 1
				City.updateOceanHeight(-1)
				get_node("../BottomBar/HoverText").text = "Ocean height lowered to %s" % [Global.oceanHeight]
		
		'damage_button':
			Global.mapTool = Global.Tool.NONE
			City.calculate_damage()
		
		'satisfaction_button':
			Global.mapTool = Global.Tool.NONE
			City.calculate_satisfaction()
			get_node("../BottomBar/HoverText").text = "Flooding damage calculated"
		
		'quicksave_button':
			Global.mapTool = Global.Tool.NONE
			if not Global.mapPath.empty():
				SaveLoad.saveMapData(Global.mapPath)
				get_node("../BottomBar/HoverText").text = "Map data saved"
			else:
				OS.alert('There is no existing save file to quicksave to, please use the Save button to make a new save file.', 'No Save File')
		
		'rotate_camera_button':
			Global.mapTool = Global.Tool.NONE
			get_node("../../Camera2D").rotateCamera(1)
			get_node("../../VectorMap").rotate_map()

		'zoom_out_button':
			get_node("../../Camera2D").zoom_out()
			Global.mapTool = Global.Tool.NONE
		
		'zoom_in_button':
			print("ZOOMIN")
			get_node("../../Camera2D").zoom_in()
			Global.mapTool = Global.Tool.NONE

func deactivateButtons():
	for i in group.get_buttons():
		i.release_focus()
		i.pressed = false

func updateAmounts():
	#The buttons are all part of a button group so we can get them all this way
	for i in group.get_buttons():
		#The buttons are named in a way where they correspond to the items in inventory
		var buttonName = i.get_name()
		#Removes the text at the end that says '_button'
		var item = buttonName.substr(0, buttonName.length() - 7)
		if Inventory.items[item] > 0:
			# Only add the inventory indicator if we have some of that item.
			i.get_node("BG").visible = true
			i.get_node("BG/Amount").text = str(Inventory.items[item])
		else:
			#If we have none, hide the indicator
			i.get_node("BG").visible = false
