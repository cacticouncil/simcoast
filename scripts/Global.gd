# Global Values
# Acts as a singleton and is loaded first with every other script

extends Node

const MAP_EDGE_BUFFER = 150			# Space beyond map for camera

const TILE_WIDTH = 64
const TILE_HEIGHT = 32

const MAX_HEIGHT = 40				# Maximum vertical height for any tile

const MIN_MAP_SIZE = 8
const MAX_MAP_SIZE = 64

const MAX_CONNECTION_HEIGHT = 100		# Largest amount of height allowed to consider tiles connected

const TICK_DELAY = 0.05#Time between ticks

var mapName = ""
var mapPath = ""
var mapWidth = 16
var mapHeight = 16

var mapTool = Tool.NONE
var tileMap = initTileMap()

var seaLevel = 2       # World value that ocean resets to after a storm surge
var oceanHeight = 0    # Current ocean level on map

#var month = 0
#var year = 2022

# Values by Camera2D to rotate camera and VectorMap to draw tiles
var camDirection = 0
var rowRange = range(0, mapWidth, 1)
var colRange = range(0, mapHeight, 1)

# For Economy AI use only (see number_of_zones.gd)
var numZones = 0
var numPeople = 0


# Economy AI constants
const ZONE_BALANCE = -.01

# To know if game is paused
var isPaused = false
var currentWeatherState = 0;

func initTileMap():
	var tm = []
	
	for _i in range(mapWidth):
		var row = []
		row.resize(mapHeight)
		tm.append(row)

	for i in mapHeight:
		for j in mapWidth:
			tm[i][j] = Tile.new(i, j, 0, 0, 0, 0, 0, [0, 0, 0, 0, 0], 0, Econ.TILE_BASE_VALUE, 0)
	
	return tm

# Map Tool Buttons that are used on map tiles
enum Tool {
	NONE,
	INCREASE_TAX,
	DECREASE_TAX,
	BASE_DIRT,
	BASE_ROCK,
	BASE_SAND,
	BASE_OCEAN,
	ZONE_SINGLE_FAMILY,
	ZONE_MULTI_FAMILY,
	ADD_RES_BLDG,
	ADD_RES_PERSON,
	ZONE_COM,
	ADD_COM_BLDG,
	ADD_COM_PERSON,
	INF_FIRE_STATION,
	INF_HOSPITAL,
	INF_POLICE_STATION,
	INF_PARK,
	INF_LIBRARY,
	INF_MUSEUM,
	INF_SCHOOL,
	INF_ROAD,
	INF_BRIDGE,
	INF_SEWAGE_FACILITY,
	INF_WASTE_TREATMENT,
	INF_UTILITIES_PLANT,
	INF_BEACH_ROCKS,
	INF_BEACH_GRASS,
	SENSOR_TIDE,
	SENSOR_RAIN,
	WATER,
	CLEAR_TILE,
	REPAIR,
	LAYER_WATER,
	CLEAR_WATER,
	COPY_TILE,
	PASTE_TILE
}
