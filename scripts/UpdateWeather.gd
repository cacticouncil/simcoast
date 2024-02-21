extends Node

var rng = RandomNumberGenerator.new()

func update_weather():
	if Weather.weatherOn:
		if UpdateDate.month == UpdateDate.Months.September || UpdateDate.month == UpdateDate.Months.October:
			Weather.probStorm = .005
		elif UpdateDate.month == UpdateDate.Months.August || UpdateDate.month == UpdateDate.Months.November:
			Weather.probStorm = .0025
		else:
			Weather.probStorm = .0005
			
		#random generate between 0 and 1, if less than prob storm then there will be a storm
		rng.randomize()
		if !Weather.currentlyStorming && rng.randf() < Weather.probStorm:
			print("Storming")
			Weather.currentlyStorming = true
			var stormType = rng.randf()
			if stormType < Weather.probTropicalStorm:
				Global.currentWeatherState = Weather.WeatherStates.TROPICAL_STORM
				print("Tropical Storm")
			else:
				var minorMajor = rng.randf()
				if (minorMajor < Weather.probMinorHurricane):
					var category = rng.randf()
					if  category < Weather.probCat1:
						Global.currentWeatherState = Weather.WeatherStates.HURRICANE_1
						print("Cat 1")
					else:
						Global.currentWeatherState = Weather.WeatherStates.HURRICANE_2
						print("Cat 2")
				else:
					var category = rng.randf()
					if category < Weather.probCat3:
						Global.currentWeatherState = Weather.WeatherStates.HURRICANE_3
						print("Cat 3")
					else:
						if category > (1 - Weather.probCat5):
							Global.currentWeatherState = Weather.WeatherStates.HURRICANE_5
							print("Cat 5")
						else:
							Global.currentWeatherState = Weather.WeatherStates.HURRICANE_4
							print("Cat 4")
		else: 
			#eventually add light rain
			if (Weather.currentlyStorming && Weather.ticksStorming > (Weather.maximumStormTicks - rng.randf_range(0, Weather.maximumStormTicks - 5))):
				Global.currentWeatherState = Weather.WeatherStates.CLEAR
				Weather.currentlyStorming = false
				Weather.ticksStorming = 0
				print("Storm ran out of time") 
			elif (Weather.currentlyStorming):
				Weather.ticksStorming = Weather.ticksStorming + 1
				print("Storm continues")
	else:
		pass
