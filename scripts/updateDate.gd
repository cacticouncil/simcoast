extends Node

const MONTH_TICKS = 100
var ticksSinceLastMonthChange = 0

enum Months {
	January,
	February,
	March,
	April,
	May,
	June,
	July,
	August,
	September,
	October,
	November,
	December
}

var month = Months.April
var year = 2022

func update_date():
	ticksSinceLastMonthChange += 1
	#update profit display weekly
	if ticksSinceLastMonthChange % (MONTH_TICKS/4) == 0:
		Econ.updateProfitDisplay()
	if (ticksSinceLastMonthChange >= MONTH_TICKS):
		ticksSinceLastMonthChange = 0
		if (month == Months.December):
			month = Months.January
			year += 1
		else:
			month += 1
		update_month_display()
		Econ.profit()
		UpdatePopulation.calc_pop_growth()
		
		if Global.closeBeach:
			Global.closeBeach = false
			print("Closing beach")
			Global.beginBeachEvacuation = true
			for i in Global.mapHeight:
				for j in Global.mapWidth:
					var currTile = Global.tileMap[i][j]
					if currTile.on_beach:
						currTile.pre_evacuation_residents = max(currTile.data[2], currTile.pre_evacuation_residents)
		elif Global.beginBeachEvacuation:
			print("Stay evacuated for storm month")
			Global.stayEvacuated = true
			Global.beginBeachEvacuation = false
		elif Global.stayEvacuated:
			print("Move back in")
			Global.moveBackIn = true
			Global.stayEvacuated = false
		elif Global.moveBackIn:
			print("Everyone's moved back in")
			Global.moveBackIn = false

func update_month_display():
	get_node("/root/CityMap/HUD/Date/Month").text = Months.keys()[month]
	get_node("/root/CityMap/HUD/Date/Year").text = str(year)
