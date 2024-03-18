extends Node
# sea level rate is 3.3 +- 0.4 mm/year
# add 0.275 a month
# add or subtract a scale of 0.03 a month
# if storm and scale is more than half than storm surge
# store in variable

enum SeaStates{
	STORM_SURGE,
	NO_STORM
}
var seaOn = true
var currentSeaLevel = 0
var currentMonth = UpdateDate.month
var currentSurge = SeaStates.NO_STORM
var futureSurge = SeaStates.NO_STORM
var sensorPresent = false
# recorded sea levels by tide sensor
var counter = -1
var allSeaLevels = []
func _ready():
	pass # Replace with function body.
