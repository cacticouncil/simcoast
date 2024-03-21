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
func update_wind_level():
	if WindLevel.windOn:
		if WindLevel.currentMonth == UpdateDate.month:
			if (WindLevel.currentMonth == UpdateDate.Months.December):
				WindLevel.currentMonth = UpdateDate.Months.January
			else:
				WindLevel.currentMonth += 1
		
			# updates every month
			if WindLevel.sensorPresent == true:
				WindLevel.allWindLevels.append(WindLevel.currentWindLevel)
				print(WindLevel.currentWindLevel)
			
			# preparations month 
			if Weather.willStorm == true:
				WindLevel.counter = 1

			# storm month
			elif Weather.currentlyStorming == true:
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
		
		if WindLevel.counter >= 0:
			ticksChange += 1
			if ticksChange == 200:
				WindLevel.counter -=1
				ticksChange = 0
				if Weather.futureType == Weather.WeatherStates.TROPICAL_STORM:
					var wind = randi() % (32 - 18 + 1) + 18
					WindLevel.currentWindLevel = wind
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_1:
					var wind = randi() % (42 - 33 + 1) + 33
					WindLevel.currentWindLevel = wind
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_2:
					var wind = randi() % (49 - 43 + 1) + 43
					WindLevel.currentWindLevel = wind
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_3:
					var wind = randi() % (58 - 50 + 1) + 50
					WindLevel.currentWindLevel = wind
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_4:
					var wind = randi() % (70 - 59 + 1) + 59 
					WindLevel.currentWindLevel = wind
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_5:
					var wind = randi() % (85 - 71 + 1) + 71
					WindLevel.currentWindLevel = wind
				else: 
					var wind = randi() % (17 + 1) 
					WindLevel.currentWindLevel = wind
					
				if WindLevel.sensorPresent == true:
					print(WindLevel.currentWindLevel)
