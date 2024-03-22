extends Node
# sea level rate is 3.3 +- 0.4 mm/year
# add 0.275 a month
# add or subtract a scale of 0.03 a month
# if storm and scale is more than half than storm surge
# store in variable

var rateIncrease = 3.3
var ticksChange = 0
var variation = RandomNumberGenerator.new()
var variationSign = RandomNumberGenerator.new()
func update_sea_level():
	if SeaLevel.seaOn:
		if SeaLevel.currentMonth == UpdateDate.month:
			if (SeaLevel.currentMonth == UpdateDate.Months.December):
				SeaLevel.currentMonth = UpdateDate.Months.January
				if SeaLevel.sensorPresent == true:
					print("S", SeaLevel.allSeaLevels)
			else:
				SeaLevel.currentMonth += 1
		
			# updates every month
			SeaLevel.currentSurge = SeaLevel.futureSurge
			if SeaLevel.sensorPresent == true:
				SeaLevel.allSeaLevels.append(SeaLevel.currentSeaLevel)
				print("sea level: ",SeaLevel.currentSeaLevel)
			
			# preparations month 
			if Weather.willStorm == true:
				SeaLevel.counter = 2

			# storm month
			elif Weather.currentlyStorming == true:
				if SeaLevel.currentSurge == SeaLevel.SeaStates.NO_STORM:
					SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)
				else:
					if Weather.currentType == Weather.WeatherStates.TROPICAL_STORM:
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)*1.05
					elif Weather.currentType == Weather.WeatherStates.HURRICANE_1:
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)*1.1
					elif Weather.currentType == Weather.WeatherStates.HURRICANE_2:
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)*1.3
					elif Weather.currentType == Weather.WeatherStates.HURRICANE_3:
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)*1.5
					elif Weather.currentType == Weather.WeatherStates.HURRICANE_4:
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)*1.7
					elif Weather.currentType == Weather.WeatherStates.HURRICANE_5:
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)*2
					else: 
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)
		
			# every other month 
			else:
				if UpdateDate.month == UpdateDate.Months.December || UpdateDate.month == UpdateDate.Months.February || UpdateDate.month == UpdateDate.Months.April:
					SeaLevel.currentSeaLevel += (rateIncrease*0.7/12)
				elif UpdateDate.month == UpdateDate.Months.January || UpdateDate.month == UpdateDate.Months.March || UpdateDate.month == UpdateDate.Months.May:
					SeaLevel.currentSeaLevel -= (rateIncrease*0.5/12)
				elif UpdateDate.month == UpdateDate.Months.June || UpdateDate.month == UpdateDate.Months.July || UpdateDate.month == UpdateDate.Months.August:
					SeaLevel.currentSeaLevel += (rateIncrease/12)
				else:
					SeaLevel.currentSeaLevel += (rateIncrease*1.2/12)
		
		if SeaLevel.counter >= 0:
			ticksChange += 1
			if ticksChange == 150:
				SeaLevel.counter -=1
				ticksChange = 0
				if SeaLevel.futureSurge == SeaLevel.SeaStates.NO_STORM:
					SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)/3
				else:
					if Weather.futureType == Weather.WeatherStates.TROPICAL_STORM:
						SeaLevel.currentSeaLevel += (((rateIncrease*1.5/12)+0.1)/3)*1.05
					elif Weather.futureType == Weather.WeatherStates.HURRICANE_1:
						SeaLevel.currentSeaLevel += (((rateIncrease*1.5/12)+0.1)/3)*1.1
					elif Weather.futureType == Weather.WeatherStates.HURRICANE_2:
						SeaLevel.currentSeaLevel += (((rateIncrease*1.5/12)+0.1)/3)*1.3
					elif Weather.futureType == Weather.WeatherStates.HURRICANE_3:
						SeaLevel.currentSeaLevel += (((rateIncrease*1.5/12)+0.1)/3)*1.5
					elif Weather.futureType == Weather.WeatherStates.HURRICANE_4:
						SeaLevel.currentSeaLevel += (((rateIncrease*1.5/12)+0.1)/3)*1.7
					elif Weather.futureType == Weather.WeatherStates.HURRICANE_5:
						SeaLevel.currentSeaLevel += (((rateIncrease*1.5/12)+0.1)/3)*2
					else: 
						SeaLevel.currentSeaLevel += ((rateIncrease*1.5/12)+0.1)/3
				if SeaLevel.sensorPresent == true:
					print(SeaLevel.currentSeaLevel)
