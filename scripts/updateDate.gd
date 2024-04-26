extends Node

var DATE_TICKS = 100
var ticksSinceLastWeekChange = 0

enum Weeks {
	Week1,
	Week2,
	Week3,
	Week4
}
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
var week = Weeks.Week1
var month = Months.April
var year = 2022

func get_date_data():
	var data = {
		"ticksSinceLastWeekChange": ticksSinceLastWeekChange,
		"month": month,
		"year": year
	}
	
	return data
	
func load_date_data(data):
	for key in data:
		self.set(key, data[key])

func update_date():
	if Weather.willStorm == true:
		if RainLevel.sensorPresent == true:
			DATE_TICKS = 500
		elif WindLevel.sensorPresent == true:
			DATE_TICKS = 350
		elif SeaLevel.sensorPresent == true:
			DATE_TICKS = 250
		else:
			DATE_TICKS = 100
	else:
		DATE_TICKS = 100
	ticksSinceLastWeekChange += 1
	#update profit display weekly
	if ticksSinceLastWeekChange % (DATE_TICKS) == 0:
		Econ.updateProfitDisplay()
	if (ticksSinceLastWeekChange >= DATE_TICKS):
		ticksSinceLastWeekChange = 0
		if (week == Weeks.Week4):
			week = Weeks.Week1
			if (month == Months.December):
				month = Months.January
				year += 1
			else:
				month += 1
		else:
			week += 1
		update_date_display()
		Econ.profit()
		UpdatePopulation.calc_pop_growth()
		City.calculate_wear_and_tear()

func update_date_display():
	if week == Weeks.Week1:
		get_node("/root/CityMap/HUD/Date/Week").text = "Week 1"
	elif week == Weeks.Week2:
		get_node("/root/CityMap/HUD/Date/Week").text = "Week 2"
	elif week == Weeks.Week3:
		get_node("/root/CityMap/HUD/Date/Week").text = "Week 3"
	else:
		get_node("/root/CityMap/HUD/Date/Week").text = "Week 4"
	get_node("/root/CityMap/HUD/Date/Month").text = Months.keys()[month]
	get_node("/root/CityMap/HUD/Date/Year").text = str(year)
