extends Node

var windOn = true
var currentWindLevel = 0
var currentMonth = UpdateDate.month
var currentWeek = UpdateDate.week
var sensorPresent = false
# recorded wind levels by wind sensor
var counter = 0
var allWindLevels = []
var weeklyWindLevels = []
var monthlyWindLevels = []
func _ready():
	pass # Replace with function body.
