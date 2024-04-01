extends Node

var MONTH_TICKS = 100
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
	if Weather.willStorm == true:
		if RainLevel.sensorPresent == true:
			MONTH_TICKS = 500
		elif WindLevel.sensorPresent == true:
			MONTH_TICKS = 350
		elif SeaLevel.sensorPresent == true:
			MONTH_TICKS = 250
		else:
			MONTH_TICKS = 100
	else:
		MONTH_TICKS = 100
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

func update_month_display():
	get_node("/root/CityMap/HUD/Date/Month").text = Months.keys()[month]
	get_node("/root/CityMap/HUD/Date/Year").text = str(year)
