extends Node

var rng = RandomNumberGenerator.new()

func update_weather():
	if Weather.weatherOn:
		# check to see if a storm will happen the next month
		if Weather.currentMonth == UpdateDate.month:
			#update monthly
			if (Weather.currentMonth == UpdateDate.Months.December):
				Weather.currentMonth = UpdateDate.Months.January
			else:
				Weather.currentMonth += 1
			
			Weather.currentlyStorming = Weather.willStorm
			Weather.currentType = Weather.futureType
			Global.currentWeatherState = Weather.currentType
			if Weather.currentlyStorming == true:
				print("currently storming")
			#probabilities for most likely storm months
			if Weather.currentMonth == UpdateDate.Months.September || Weather.currentMonth == UpdateDate.Months.October:
				Weather.probStorm = .5
			elif Weather.currentMonth == UpdateDate.Months.August || Weather.currentMonth== UpdateDate.Months.November:
				Weather.probStorm = .25
			else:
				Weather.probStorm = .05
			rng.randomize()
			if(rng.randf() < Weather.probStorm && !Weather.currentlyStorming):
				Weather.willStorm = true
				var stormType = rng.randf()
				if stormType < Weather.probTropicalStorm:
					Weather.futureType = Weather.WeatherStates.TROPICAL_STORM
					print("Tropical Storm (1month)")
				else:
					var minorMajor = rng.randf()
					if (minorMajor < Weather.probMinorHurricane):
						var category = rng.randf()
						if  category < Weather.probCat1:
							Weather.futureType = Weather.WeatherStates.HURRICANE_1
							print("Cat 1 (1month)")
						else:
							Weather.futureType = Weather.WeatherStates.HURRICANE_2
							print("Cat 2 (1month)")
					else:
						var category = rng.randf()
						if category < Weather.probCat3:
							Weather.futureType = Weather.WeatherStates.HURRICANE_3
							print("Cat 3 (1month)")
						else:
							if category > (1 - Weather.probCat5):
								Weather.futureType = Weather.WeatherStates.HURRICANE_5
								print("Cat 5 (1month)")
							else:
								Weather.futureType = Weather.WeatherStates.HURRICANE_4
								print("Cat 4 (1month)")
			else:
				print("no storms (1 month)")
				Weather.willStorm = false
				Weather.futureType = Weather.WeatherStates.CLEAR
			
		#else: 
			#eventually add light rain
			#if (Weather.currentlyStorming && Weather.ticksStorming > (Weather.maximumStormTicks - rng.randf_range(0, Weather.maximumStormTicks - 5))):
				#Global.currentWeatherState = Weather.WeatherStates.CLEAR
				#Weather.currentlyStorming = false
				#Weather.ticksStorming = 0
				#print("Storm ran out of time") 
			#elif (Weather.currentlyStorming):
				#Weather.ticksStorming = Weather.ticksStorming + 1
				#print("Storm continues")
	else:
		pass
