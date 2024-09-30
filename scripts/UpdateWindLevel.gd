extends Node
#in miles per second
#No storm - 0-15
#Tropical storm - 18-32
#Cat 1 - 33-42
#Cat 2 - 43-49
#Cat 3 - 50-58
#Cat 4 - 59-70
#Cat 5 - 71-85

var rng = RandomNumberGenerator.new()
var ticksChange = 0
var counts = false

func update_wind_level():
	if WindLevel.windOn:
		if WindLevel.currentWeek == UpdateDate.week:
			if (WindLevel.currentWeek == UpdateDate.Weeks.Week4):
				WindLevel.currentWeek = UpdateDate.Weeks.Week1
				if WindLevel.sensorPresent == true:
					print("W", WindLevel.allWindLevels)
			else:
				WindLevel.currentWeek += 1
		
			# updates every month
			if WindLevel.sensorPresent == true:
				WindLevel.allWindLevels.append(WindLevel.currentWindLevel)
				print("wind level: ",WindLevel.currentWindLevel)
			
			# preparations month 
			if Weather.willStorm == true:
				WindLevel.counter = 1
				counts = true
			else:
				counts = false

			# storm month
			if Weather.currentlyStorming == true:
				if Weather.currentType == Weather.WeatherStates.TROPICAL_STORM:
					var wind = randi() % (32 - 18 + 1) + 18
					WindLevel.currentWindLevel = wind
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_1:
					var wind = randi() % (42 - 33 + 1) + 33
					WindLevel.currentWindLevel = wind
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_2:
					var wind = randi() % (49 - 43 + 1) + 43
					WindLevel.currentWindLevel = wind
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_3:
					var wind = randi() % (58 - 50 + 1) + 50
					WindLevel.currentWindLevel = wind
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_4:
					var wind = randi() % (70 - 59 + 1) + 59
					WindLevel.currentWindLevel = wind
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_5:
					var wind = randi() % (85 - 71 + 1) + 71
					WindLevel.currentWindLevel = wind
				else: 
					var wind = randi() % (17 + 1) 
					WindLevel.currentWindLevel = wind
		
			# every other month 
			else:
				var wind = randi() % (17 + 1) 
				WindLevel.currentWindLevel = wind
		
		if counts == true:
			ticksChange += 1
			if ticksChange >= 250:
				counts = false
				WindLevel.counter -=1
				ticksChange = 0
				if Weather.futureType == Weather.WeatherStates.TROPICAL_STORM:
					var wind = randi() % (32 - 18 + 1) + 18
					WindLevel.currentWindLevel = wind
					if WindLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Strong winds", "res://assets/weather/strong_wind.jpg", "EED202")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_1:
					var wind = randi() % (42 - 33 + 1) + 33
					WindLevel.currentWindLevel = wind
					if WindLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Strong winds", "res://assets/weather/strong_wind.jpg", "EED202")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_2:
					var wind = randi() % (49 - 43 + 1) + 43
					WindLevel.currentWindLevel = wind
					if WindLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Strong winds", "res://assets/weather/strong_wind.jpg", "FF7800")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_3:
					var wind = randi() % (58 - 50 + 1) + 50
					WindLevel.currentWindLevel = wind
					if WindLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Strong winds", "res://assets/weather/strong_wind.jpg", "FF7800")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_4:
					var wind = randi() % (70 - 59 + 1) + 59 
					WindLevel.currentWindLevel = wind
					if WindLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Strong winds", "res://assets/weather/strong_wind.jpg", "D0342C")
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_5:
					var wind = randi() % (85 - 71 + 1) + 71
					WindLevel.currentWindLevel = wind
					if WindLevel.sensorPresent == true:
						get_node("/root/Overlay").warning_pop("Strong winds", "res://assets/weather/strong_wind.jpg", "D0342C")
				else: 
					var wind = randi() % (17 + 1) 
					WindLevel.currentWindLevel = wind
					
				if WindLevel.sensorPresent == true:
					print("wind level: ",WindLevel.currentWindLevel)
					#get_node("/root/Overlay").warning_wind_pop("Insufficient Funds")
