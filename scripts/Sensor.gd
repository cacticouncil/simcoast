class_name Sensor extends Node

# name of sensor
var sensor_name
# sensor information
var sensor_info
# information that goes on the popup
var sensor_ext_info
#whether sensor is unlocked or not
var sensor_status
# current available to use sensors of this type
var sensor_amount
# requirements to unlock sensor
var sensor_req
# used to activate buy popup display
var buy_bttn = false
# used to activate information popup display
var info_bttn = false
# current price of the sensor
var price = 5000
# if player cannot buy sensor
var cant_buy = false

# Called when the node enters the scene tree for the first time.
func _init(var n, var info, var e, var r):
	sensor_ext_info = e
	sensor_name = n
	sensor_info = info
	sensor_status = false
	sensor_amount = 0
	sensor_req = r
	if n == "Tide Gauge":
		price = 0

func to_dict():
	return {
		"sensor_name": sensor_name,
		"sensor_info": sensor_info,
		"sensor_ext_info": sensor_ext_info,
		"sensor_status": sensor_status,
		"sensor_amount": sensor_amount,
		"sensor_req": sensor_req,
		"buy_bttn": buy_bttn,
		"info_bttn": info_bttn,
		"price": price,
		"cant_buy": cant_buy
	}

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
