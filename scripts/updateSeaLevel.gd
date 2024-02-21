extends Node
# sea level rate is 3.3 +- 0.4 mm/year
# add 0.275 a month
# add or subtract a scale of 0.03 a month
# if storm and scale is more than half than storm surge
# store in variable


var variation = RandomNumberGenerator.new()
var variationSign = RandomNumberGenerator.new()
func update_sea_level():
	if SeaLevel.seaOn:
		# new month, increased sea level
		if SeaLevel.currentMonth != UpdateDate.month:
			# update sea level month
			SeaLevel.currentMonth = UpdateDate.month
			# increase baseline monthly sea level
			SeaLevel.currentSeaLevel += 0.275
			#random generate between 0 and 1 for intensity of sea level variation
			variation.randomize()
			#random generate between 0 and 1, if less than 0.5 then negative sea level variation
			#if more than 0.5, then positive sea level variation
			variationSign.randomize()
			if variationSign.randf() < 0.5:
				SeaLevel.currentSeaLevel -= 0.03*variation.randf()
			else: 
				SeaLevel.currentSeaLevel += 0.03*variation.randf()
			if SeaLevel.sensorPresent == true:
				SeaLevel.allSeaLevels.append(SeaLevel.currentSeaLevel)
				print(SeaLevel.currentSeaLevel)

