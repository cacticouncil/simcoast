extends Node
#in mm/hr
#No storm - less than 0.5
#Tropical storm - 0.5-4
#Cat 1 - 4-8
#Cat 2 - 8-15
#Cat 3 - 15-25
#Cat 4 - 25-35
#Cat 5 - 35-55

var rainOn = true
var currentRainLevel = 0
var currentMonth = UpdateDate.month
var sensorPresent = false
# recorded sea levels by tide sensor
var counter = 0
var allRainLevels = []
func _ready():
	pass # Replace with function body.
