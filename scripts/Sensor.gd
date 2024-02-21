class_name Sensor extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sensor_name
var sensor_info
var sensor_ext_info
var sensor_status
var sensor_amount
var sensor_req
var buy_bttn = false
var info_bttn = false
var price = 5000
var cant_buy = false
# Called when the node enters the scene tree for the first time.
func _init(var n, var info, var e, var r):
	sensor_ext_info = e
	sensor_name = n
	sensor_info = info
	sensor_status = false
	sensor_amount = 0
	sensor_req = r
	
func get_status():
	return sensor_status

func set_status(var s):
	sensor_status = s

func get_name():
	return sensor_name

func get_info():
	return sensor_info

func get_req():
	return sensor_req

func get_amount():
	return sensor_amount
	
func get_ext_info():
	return sensor_ext_info
	
func increase_amount():
	sensor_amount +=1

func decrease_amount():
	sensor_amount -=1
