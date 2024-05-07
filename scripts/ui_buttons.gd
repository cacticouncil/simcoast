extends Control

export(ButtonGroup) var group

var mapName
var mapPath
var savePopup
var loadPopup

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in group.get_buttons():
		i.connect("pressed", self, "button_pressed")
		i.connect("mouse_entered", self, "button_hover", [i])
		i.connect("mouse_exited", self, "button_exit")

func button_exit():
	get_node("../BottomBar/HoverText").text = ""

# Displays detailed tool information when hovering
func button_hover(button):
	var toolInfo = get_node("../BottomBar/HoverText")

	match button.get_name():
		'ocean_button':
			toolInfo.text = "Replace base tile with ocean"
		'single_family_zone_button':
			toolInfo.text = "Single Family Zone   (Right Click: Remove zoning)"
		'multi_family_zone_button':
			toolInfo.text = "Multi Family Zone   (Right Click: Remove zoning)"
		'com_zone_button':
			toolInfo.text = "Commercial Zone   (Right Click: Remove zoning)"
		'utility_plant_button':
			toolInfo.text = "Build Utilities Plant"
		'road_button':
			toolInfo.text = "Built infrastructure (road/utility/water) tile   (Right Click: Remove infrastructure)"
		'park_button':
			toolInfo.text = "Built Park   (Right Click: Remove park)"	
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

func button_pressed():
	var mapNode = get_node("../../")
	
	match group.get_pressed_button().get_name():
		'ocean_button':
			Global.mapTool = Global.Tool.BASE_OCEAN
		'single_family_zone_button':
			Global.mapTool = Global.Tool.ZONE_SINGLE_FAMILY
		'multi_family_zone_button':
			Global.mapTool = Global.Tool.ZONE_MULTI_FAMILY
		'com_zone_button':
			Global.mapTool = Global.Tool.ZONE_COM
		'utility_plant_button':
			Global.mapTool = Global.Tool.INF_UTILITIES_PLANT
		'park_button':
			Global.mapTool = Global.Tool.INF_PARK
		'road_button':
			Global.mapTool = Global.Tool.INF_ROAD
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
