class_name Sensor extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sensor_name
var sensor_info

# Called when the node enters the scene tree for the first time.
func _init(var n, var info):
	sensor_name = n
	sensor_info = info

func get_name():
	return sensor_name

func get_info():
	return sensor_info
