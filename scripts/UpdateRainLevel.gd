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
func update_rain_level():
	if RainLevel.rainOn:
		if RainLevel.currentMonth == UpdateDate.month:
			if (RainLevel.currentMonth == UpdateDate.Months.December):
				RainLevel.currentMonth = UpdateDate.Months.January
				if RainLevel.sensorPresent == true:
					print("R", RainLevel.allRainLevels)
			else:
				RainLevel.currentMonth += 1
		
			# updates every month
			if RainLevel.sensorPresent == true:
				RainLevel.allRainLevels.append(RainLevel.currentRainLevel)
				print("rain level",RainLevel.currentRainLevel)
			
			# preparations month 
			if Weather.willStorm == true:
				RainLevel.counter = 1

			# storm month
			elif Weather.currentlyStorming == true:
				if Weather.currentType == Weather.WeatherStates.TROPICAL_STORM:
					var rain = randi() % (4) + 1
					RainLevel.currentRainLevel = rain
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_1:
					var rain = randi() % (8 - 4 + 1) + 4
					RainLevel.currentRainLevel = rain
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_2:
					var rain = randi() % (15 - 8 + 1) + 8
					RainLevel.currentRainLevel = rain
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_3:
					var rain = randi() % (25 - 15 + 1) + 15
					RainLevel.currentRainLevel = rain
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_4:
					var rain = randi() % (35 - 25 + 1) + 25
					RainLevel.currentRainLevel = rain
				elif Weather.currentType == Weather.WeatherStates.HURRICANE_5:
					var rain = randi() % (55 - 35 + 1) + 35
					RainLevel.currentRainLevel = rain
				else: 
					var rain = randf() 
					RainLevel.currentRainLevel = rain
		
			# every other month 
			else:
				var rain = randf() 
				RainLevel.currentRainLevel = rain
		
		if RainLevel.counter >= 0:
			ticksChange += 1
			if ticksChange == 200:
				RainLevel.counter -=1
				ticksChange = 0
				if Weather.futureType == Weather.WeatherStates.TROPICAL_STORM:
					var rain = randi() % (4) + 1
					RainLevel.currentRainLevel = rain
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_1:
					var rain = randi() % (8 - 4 + 1) + 4
					RainLevel.currentRainLevel = rain
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_2:
					var rain = randi() % (15 - 8 + 1) + 8
					RainLevel.currentRainLevel = rain
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_3:
					var rain = randi() % (25 - 15 + 1) + 15
					RainLevel.currentRainLevel = rain
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_4:
					var rain = randi() % (35 - 25 + 1) + 25
					RainLevel.currentRainLevel = rain
				elif Weather.futureType == Weather.WeatherStates.HURRICANE_5:
					var rain = randi() % (55 - 35 + 1) + 35
					RainLevel.currentRainLevel = rain
				else: 
					var rain = randf()
					RainLevel.currentRainLevel = rain
					
				if RainLevel.sensorPresent == true:
					print(RainLevel.currentRainLevel)
