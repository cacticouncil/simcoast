extends ScrollContainer

var group = preload("res://toolbar_button_group.tres")

var mapName
var mapPath
var savePopup
var loadPopup

var toolbarSectionScene = preload("res://ui/hud/Toolbar/ToolbarSection.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_v_scrollbar().rect_scale.x = 0
	
	var infrastructureButtons = [
		["road", "res://assets/buttons/road"], 
		["bridge", "res://assets/buttons/bridge"], 
		["water", "res://assets/buttons/water"]
	]
	var infrastructureSection = toolbarSectionScene.instance()
	infrastructureSection.add_button("Infrastructure", infrastructureButtons)
	$VBoxContainer.add_child(infrastructureSection)
	infrastructureSection.set_bg(infrastructureSection.rect_size, Color("526e7584"))
	
	var zoneButtons = [
		["house", "res://assets/buttons/lt_res_zone"], 
		["apartment", "res://assets/buttons/hv_res_zone"], 
		["shop", "res://assets/buttons/lt_com_zone"],
		["super shop", "res://assets/buttons/hv_com_zone"]
	]
	var zoneSection = toolbarSectionScene.instance()
	zoneSection.add_button("Zones", zoneButtons)
	$VBoxContainer.add_child(zoneSection)
	zoneSection.set_bg(zoneSection.rect_size, Color("e03c3c3c"))
	
	var industrialButtons = [
		["utility plant", "res://assets/buttons/power_plant"], 
		["sewage facility", "res://assets/buttons/sewage"], 
		["waste treatment", "res://assets/buttons/wasteTreatment"]
	]
	var industrialSection = toolbarSectionScene.instance()
	industrialSection.add_button("Industrial", industrialButtons)
	$VBoxContainer.add_child(industrialSection)
	industrialSection.set_bg(industrialSection.rect_size, Color("526e7584"))
	
	var emergencyServiceButtons = [
		["fire station", "res://assets/buttons/fireStation"], 
		["hospital", "res://assets/buttons/hospital"], 
		["police station", "res://assets/buttons/policeStation"]
	]
	var emergencyServiceSection = toolbarSectionScene.instance()
	emergencyServiceSection.add_button("Emergency Services", emergencyServiceButtons)
	$VBoxContainer.add_child(emergencyServiceSection)
	emergencyServiceSection.set_bg(emergencyServiceSection.rect_size, Color("e03c3c3c"))
	
	var publicServiceButtons = [
		["park", "res://assets/buttons/park"], 
		["library", "res://assets/buttons/library"], 
		["museum", "res://assets/buttons/museum"],
		["school", "res://assets/buttons/school"]
	]
	var publicServiceSection = toolbarSectionScene.instance()
	publicServiceSection.add_button("Public Services", publicServiceButtons)
	$VBoxContainer.add_child(publicServiceSection)
	publicServiceSection.set_bg(publicServiceSection.rect_size, Color("526e7584"))
	
	var sensorButtons = [
		["tide sensor", "res://assets/buttons/tide_sensor"], 
		["rain sensor", "res://assets/buttons/tide_sensor"]
	]
	var sensorSection = toolbarSectionScene.instance()
	sensorSection.add_button("Sensors", sensorButtons)
	$VBoxContainer.add_child(sensorSection)
	sensorSection.set_bg(sensorSection.rect_size, Color("e03c3c3c"))
	
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
		i.connect("mouse_entered", self, "button_hover", [i])
		i.connect("mouse_exited", self, "button_exit")
	updateAmounts()
	

func button_exit():
	get_node("../BottomBar/HoverText").text = ""

# Displays detailed tool information when hovering
func button_hover(button):
	var toolInfo = get_node("../BottomBar/HoverText")

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
		'super shop_button':
			toolInfo.text = "Heavy Commercial Zone   (Right Click: Remove zoning)"
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
	var mapNode = get_node("../../")
	
	match group.get_pressed_button().get_name():
		'increase_tax_button':
			Econ.adjust_tax_rate(0.01)
			#City.extend_map()
			#mapNode.initCamera()
		'decrease_tax_button':
			Econ.adjust_tax_rate(-0.01)
			#City.reduce_map()
			#mapNode.initCamera()
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
			Global.mapTool = Global.Tool.ZONE_LT_RES
		'apartment_button':
			Global.mapTool = Global.Tool.ZONE_HV_RES
		'add_house_button':
			Global.mapTool = Global.Tool.ADD_RES_BLDG
		'add_resident_button':
			Global.mapTool = Global.Tool.ADD_RES_PERSON
		'shop_button':
			Global.mapTool = Global.Tool.ZONE_LT_COM
		'super shop_button':
			Global.mapTool = Global.Tool.ZONE_HV_COM
		'add_building_button':
			Global.mapTool = Global.Tool.ADD_COM_BLDG
		'add_employee_button':
			Global.mapTool = Global.Tool.ADD_COM_PERSON
		'fire station_button':
			Global.mapTool = Global.Tool.INF_FIRE_STATION
		'hospital_button':
			Global.mapTool = Global.Tool.INF_HOSPITAL
		'police station_button':
			Global.mapTool = Global.Tool.INF_POLICE_STATION
		'utility plant_button':
			Global.mapTool = Global.Tool.INF_UTILITIES_PLANT
		'sewage facility_button':
			Global.mapTool = Global.Tool.INF_SEWAGE_FACILITY
		'waste treatment_button':
			Global.mapTool = Global.Tool.INF_WASTE_TREATMENT
		'park_button':
			Global.mapTool = Global.Tool.INF_PARK
		'library_button':
			Global.mapTool = Global.Tool.INF_LIBRARY
		'museum_button':
			Global.mapTool = Global.Tool.INF_MUSEUM
		'school_button':
			Global.mapTool = Global.Tool.INF_SCHOOL
		'road_button':
			Global.mapTool = Global.Tool.INF_ROAD
		'bridge_button':
			Global.mapTool = Global.Tool.INF_BRIDGE
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
		'tide sensor_button':
			Global.mapTool = Global.Tool.SENSOR_TIDE
		
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
		# 'save_button':
		# 	print("SAVE")
		# 	Global.mapTool = Global.Tool.NONE
		# 	savePopup.popup_centered()
		# 'load_button':
		# 	Global.mapTool = Global.Tool.NONE
		# 	loadPopup.popup_centered()
		# 'exit_button':
		# 	Global.mapTool = Global.Tool.NONE
		# 	get_tree().quit()

func updateAmounts():
	for i in group.get_buttons():
		#The buttons are named in a way where they correspond to the items in inventory
		var buttonName = i.get_name()
		var item = buttonName.substr(0, buttonName.length() - 7)
		if Inventory.items[item] > 0:
			i.get_node("BG").visible = true
			i.get_node("BG/Amount").text = str(Inventory.items[item])
		else:
			i.get_node("BG").visible = false
