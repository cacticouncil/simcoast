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

func get_date_data():
	var data = {
		"ticksSinceLastMonthChange": ticksSinceLastMonthChange,
		"month": month,
		"year": year
	}
	
	return data
	
func load_date_data(data):
	for key in data:
		self.set(key, data[key])

func update_date():
	ticksSinceLastMonthChange += 1
	#update profit display weekly
	if int(ticksSinceLastMonthChange) % (MONTH_TICKS/4) == 0:
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
