extends Node

var rng = RandomNumberGenerator.new()

func update_weather():
	if Weather.weatherOn:
		# check to see if a storm will happen the next week
		if Weather.currentWeek == UpdateDate.week:
			#update week
			if (Weather.currentWeek == UpdateDate.Weeks.Week4):
				Weather.currentWeek = UpdateDate.Weeks.Week1
				if (Weather.currentMonth == UpdateDate.Months.December):
					Weather.currentMonth = UpdateDate.Months.January
				else:
					Weather.currentMonth += 1
			else:
				Weather.currentWeek += 1
			
			Weather.currentlyStorming = Weather.willStorm
			Weather.currentType = Weather.futureType
			if Weather.currentType != Weather.WeatherStates.CLEAR:
				Weather.stormDamage = true
			Global.currentWeatherState = Weather.currentType
			if Weather.currentlyStorming == true:
				print("currently storming")
			#probabilities for most likely storm months
			if Weather.currentMonth == UpdateDate.Months.August || Weather.currentMonth == UpdateDate.Months.September || Weather.currentMonth == UpdateDate.Months.October:
				Weather.probStorm = .075
			elif Weather.currentMonth == UpdateDate.Months.June || Weather.currentMonth == UpdateDate.Months.July || Weather.currentMonth== UpdateDate.Months.November:
				Weather.probStorm = .025
			else:
				Weather.probStorm = 0
			rng.randomize()
			if(rng.randf() < Weather.probStorm && !Weather.currentlyStorming && !Global.moveBackIn):
				Weather.willStorm = true
				var stormType = rng.randf()
				if stormType < Weather.probTropicalStorm:
					Weather.futureType = Weather.WeatherStates.TROPICAL_STORM
					print("Tropical Storm (next week)")
				else:
					var minorMajor = rng.randf()
					if (minorMajor < Weather.probMinorHurricane):
						var category = rng.randf()
						if  category < Weather.probCat1:
							Weather.futureType = Weather.WeatherStates.HURRICANE_1
							print("Cat 1 (next week)")
						else:
							Weather.futureType = Weather.WeatherStates.HURRICANE_2
							print("Cat 2 (next week)")
					else:
						var category = rng.randf()
						if category < Weather.probCat3:
							Weather.futureType = Weather.WeatherStates.HURRICANE_3
							print("Cat 3 (next week)")
						else:
							if category > (1 - Weather.probCat5):
								Weather.futureType = Weather.WeatherStates.HURRICANE_5
								print("Cat 5 (next week)")
							else:
								Weather.futureType = Weather.WeatherStates.HURRICANE_4
								print("Cat 4 (next week)")
			else:
				print("no storms (next week)")
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
