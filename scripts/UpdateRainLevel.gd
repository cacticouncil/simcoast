extends Node
#in mm/hr
#No storm - less than 0.5
#Tropical storm - 0.5-4
#Cat 1 - 4-8
#Cat 2 - 8-15
#Cat 3 - 15-25
#Cat 4 - 25-35
#Cat 5 - 35-55

var rng = RandomNumberGenerator.new()
var ticksChange = 0
var pops = true
var counts = false

func update_rain_level():
	if RainLevel.rainOn:
		if RainLevel.currentWeek == UpdateDate.week:
			if (RainLevel.currentWeek == UpdateDate.Weeks.Week4):
				RainLevel.currentWeek = UpdateDate.Weeks.Week1
				if RainLevel.sensorPresent == true:
					print("R", RainLevel.allRainLevels)
			else:
				RainLevel.currentWeek += 1
					
			# updates every week
			if RainLevel.sensorPresent == true:
				pops = true
				RainLevel.allRainLevels.append(RainLevel.currentRainLevel)
				print("rain level: ",RainLevel.currentRainLevel)
			
			# preparations month 
			if Weather.willStorm == true:
				RainLevel.counter = 1
				counts = true
			else:
				counts = false

			# storm month
			if Weather.currentlyStorming == true:
				if Weather.currentType == Weather.WeatherStates.TROPICAL_STORM:
					var rain = randi() % (4) + 1
					RainLevel.currentRainLevel = rain
					if SeaLevel.currentSurge == SeaLevel.SeaStates.STORM_SURGE:
						get_node("/root/Overlay").warning_pop("It is storming\nStorm Surge Present", "res://assets/weather/tropical_storm.png", "EED202")
					else:
						get_node("/root/Overlay").warning_pop("It is storming", "res://assets/weather/tropical_storm.png", "EED202")
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_1:
					var rain = randi() % (8 - 4 + 1) + 4
					RainLevel.currentRainLevel = rain
					if SeaLevel.currentSurge == SeaLevel.SeaStates.STORM_SURGE:
						get_node("/root/Overlay").warning_pop("It is storming\nStorm Surge Present", "res://assets/weather/cat1.png", "EED202")
					else:
						get_node("/root/Overlay").warning_pop("It is storming", "res://assets/weather/cat1.png", "EED202")
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_2:
					var rain = randi() % (15 - 8 + 1) + 8
					RainLevel.currentRainLevel = rain
					if SeaLevel.currentSurge == SeaLevel.SeaStates.STORM_SURGE:
						get_node("/root/Overlay").warning_pop("It is storming\nStorm Surge Present", "res://assets/weather/cat2.png", "FF7800")
					else:
						get_node("/root/Overlay").warning_pop("It is storming", "res://assets/weather/cat2.png", "FF7800")
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_3:
					var rain = randi() % (25 - 15 + 1) + 15
					RainLevel.currentRainLevel = rain
					if SeaLevel.currentSurge == SeaLevel.SeaStates.STORM_SURGE:
						get_node("/root/Overlay").warning_pop("It is storming\nStorm Surge Present", "res://assets/weather/cat3.png", "FF7800")
					else:
						get_node("/root/Overlay").warning_pop("It is storming", "res://assets/weather/cat3.png", "FF7800")
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_4:
					var rain = randi() % (35 - 25 + 1) + 25
					RainLevel.currentRainLevel = rain
					if SeaLevel.currentSurge == SeaLevel.SeaStates.STORM_SURGE:
						get_node("/root/Overlay").warning_pop("It is storming\nStorm Surge Present", "res://assets/weather/cat4.png", "D0342C")
					else:
						get_node("/root/Overlay").warning_pop("It is storming", "res://assets/weather/cat4.png", "D0342C")
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_5:
					var rain = randi() % (55 - 35 + 1) + 35
					RainLevel.currentRainLevel = rain
					if SeaLevel.currentSurge == SeaLevel.SeaStates.STORM_SURGE:
						get_node("/root/Overlay").warning_pop("It is storming\nStorm Surge Present", "res://assets/weather/cat5.png", "D0342C")
					else:
						get_node("/root/Overlay").warning_pop("It is storming", "res://assets/weather/cat5.png", "D0342C")
				else: 
					var rain = randf() 
					RainLevel.currentRainLevel = rain
		
			# every other week
			else:
				var rain = randf() 
				RainLevel.currentRainLevel = rain
		
		if counts == true:
			ticksChange += 1
			if ticksChange >= 350:
				counts = false
				RainLevel.counter -=1
				ticksChange = 0
				if Weather.futureType == Weather.WeatherStates.TROPICAL_STORM:
					var rain = randi() % (4) + 1
					RainLevel.currentRainLevel = rain
					if pops == true && RainLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Light rain is expected", "res://assets/weather/heavy_rain.jpg", "EED202")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_1:
					var rain = randi() % (8 - 4 + 1) + 4
					RainLevel.currentRainLevel = rain
					if pops == true && RainLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Light rain is expected", "res://assets/weather/heavy_rain.jpg", "EED202")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_2:
					var rain = randi() % (15 - 8 + 1) + 8
					RainLevel.currentRainLevel = rain
					if pops == true && RainLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Moderate rain is expected", "res://assets/weather/heavy_rain.jpg", "FF7800")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_3:
					var rain = randi() % (25 - 15 + 1) + 15
					RainLevel.currentRainLevel = rain
					if pops == true && RainLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Moderate rain is expected", "res://assets/weather/heavy_rain.jpg", "FF7800")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_4:
					var rain = randi() % (35 - 25 + 1) + 25
					RainLevel.currentRainLevel = rain
					if pops == true && RainLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Heavy rain is expected", "res://assets/weather/heavy_rain.jpg", "D0342C")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_5:
					var rain = randi() % (55 - 35 + 1) + 35
					RainLevel.currentRainLevel = rain
					if pops == true && RainLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Heavy rain is expected", "res://assets/weather/heavy_rain.jpg", "D0342C")
				else: 
					var rain = randf()
					RainLevel.currentRainLevel = rain
					
				if RainLevel.sensorPresent == true:
					print("rain level: ",RainLevel.currentRainLevel)
