extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum WeatherStates{
	CLEAR,
	RAINY,
	TROPICAL_STORM,
	HURRICANE_1,
	HURRICANE_2,
	HURRICANE_3,
	HURRICANE_4,
	HURRICANE_5
}

var weatherOn = true

var monthsSinceLastStorm = 0;

var probRain = 0;
# 1 - probability of clear skies
# change this in UpdateWeather based on month
var probStorm = 0;
var probTropicalStorm = .4;
var probMinorHurricane = .6854;
var probCat1 = 0.5942;
var probCat2 = 0.4058;
var probMajorHurricane = .3145;
var probCat3 = 0.6632;
var probCat4 = .2947;
var probCat5 = .0421 

var ticksStorming = 0
var maximumStormTicks = UpdateDate.MONTH_TICKS / 4
var currentlyStorming = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
