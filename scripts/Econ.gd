extends Node

# Stores all global constants/functions relative to the economy implemented (Ex: land value, tile durability...)

const TILE_BASE_VALUE = 500
const BUILDING_BASE_VALUE = 50
const RESIDENT_PERSON_VALUE = 2000

#tax rates
#LEGACY VALUES, REMOVE WHEN DONE MAKING CHANGES
const TAX_INCOME_MULTIPLIER = 1000
var BASE_TAX_RATE = 0.05 # 5% #TODO: Be able to update this in-game / maybe different tax rates for commercial/residentail/industry
var LIGHT_RES_PROPERTY_RATE = BASE_TAX_RATE #land value * num buildings
var LIGHT_RES_INCOME_RATE = BASE_TAX_RATE #land value * num people
var HEAVY_RES_PROPERTY_RATE = BASE_TAX_RATE #land value * num buildings
var HEAVY_RES_INCOME_RATE = BASE_TAX_RATE #land value * num people
var COM_PROPERTY_RATE = BASE_TAX_RATE #land value * num buildings
var COM_INCOME_RATE = BASE_TAX_RATE #land value * num people

var PROPERTY_TAX = 0.01 #property tax gets set at 1% to start, which is neutral
var SALES_TAX = 0.05 #5% sales tax to start, also neutral
var INCOME_TAX = 0.025 #2.5% income tax, also neutral
#neutrality is from desirability, meaning these taxes are neither light nor heavy

# Tile Durability Constants
const REMOVE_BUILDING_DAMAGE = 0.2
const REMOVE_COMMERCIAL_BUILDING  = 0.3

#Building costs
const POWER_PLANT_COST = 10000
const SEWAGE_FACILITY_COST = 10000
const WASTE_TREATMENT_COST = 10000
const UTILITIES_PLANT_COST = 10000
const PARK_COST = 500
const ROAD_COST = 100
const BRIDGE_COST = 200
const BOARDWALK_COST = 200
const LIBRARY_COST = 3000
const MUSEUM_COST = 3000
const SCHOOL_COST = 3000
const FIRE_STATION_COST = 5000
const HOSPITAL_COST = 5000
const POLICE_STATION_COST = 5000
const WATER_COST = 5000
const REMOVE_BEACH_ROCK = 3000
const WAVE_BREAKER_COST = 2000

#Road repair costs
const ROAD_REPAIR_L_COST = 15
const ROAD_REPAIR_M_COST = 30
const ROAD_REPAIR_H_COST = 60
#Bridge repair costs
const BRIDGE_REPAIR_L_COST = 30
const BRIDGE_REPAIR_M_COST = 60
const BRIDGE_REPAIR_H_COST = 120
#Boardwalk repair costs
const BOARDWALK_REPAIR_L_COST = 30
const BOARDWALK_REPAIR_M_COST = 60
const BOARDWALK_REPAIR_H_COST = 120

#Building upkeep costs
const UTILITIES_PLANT_UPKEEP_COST = 100
const PARK_UPKEEP_COST = 10
const ROAD_UPKEEP_COST = 2
const BRIDGE_UPKEEP_COST = 4
const BOARDWALK_UPKEEP_COST = 4
const LIBRARY_UPKEEP_COST = 50
const MUSEUM_UPKEEP_COST = 50
const SCHOOL_UPKEEP_COST = 50
const FIRE_STATION_UPKEEP_COST = 100
const HOSPITAL_UPKEEP_COST = 100
const POLICE_STATION_UPKEEP_COST = 100
const SEWAGE_FACILITY_UPKEEP_COST = 100
const WASTE_TREATMENT_UPKEEP_COST = 100
const MULTI_FAMILY_UPKEEP_COST = 50
const SINGLE_FAMILY_UPKEEP_COST = 10
const UPKEEP_PER_PERSON = 2
const WAVE_BREAKER_UPKEEP_COST = 10

# Player/Mayor Constants
var money

#Income and costs
var city_income = 0 # Net Profit
var city_costs = 0 # Upkeep costs
var avg_income = 0 #avg income of a res tile
var avg_profit = 0 #avg profit of a commercial tile
#Probably not needed
var city_tax_rate = BASE_TAX_RATE
var property_tax_rate = 0.01 


func get_econ_data():
	var econData = {
		"BASE_TAX_RATE": BASE_TAX_RATE,
		"LIGHT_RES_PROPERTY_RATE": LIGHT_RES_PROPERTY_RATE,
		"LIGHT_RES_INCOME_RATE": LIGHT_RES_INCOME_RATE,
		"HEAVY_RES_PROPERTY_RATE": HEAVY_RES_PROPERTY_RATE,
		"HEAVY_RES_INCOME_RATE": HEAVY_RES_INCOME_RATE,
		"COM_PROPERTY_RATE": COM_PROPERTY_RATE,
		"COM_INCOME_RATE": COM_INCOME_RATE,
		"PROPERTY_TAX": PROPERTY_TAX,
		"SALES_TAX": SALES_TAX,
		"INCOME_TAX": INCOME_TAX,
		"money": money,
		"city_income": city_income,
		"city_costs": city_costs,
		"avg_income": avg_income,
		"avg_profit": avg_profit,
		"city_tax_rate": city_tax_rate,
		"property_tax_rate": property_tax_rate
	}
	
	return econData

func load_econ_data(data):
	if not data.empty():
		for key in data:
			self.set(key, data[key])

# adjustVal parameter takes in the exact amount loss or gain towards the player money 
# EX: if player spends $500 then adjustVal should be -500
func adjust_player_money(adjustVal):
	money += adjustVal
	var currEvent = Event.new("Money", "Amount of money", money)
	Announcer.notify(currEvent)
	currEvent.queue_free()
	get_node("/root/CityMap/HUD/HBoxContainer/Money").text = "$" + comma_values(str(money))

func purchase_structure(structureCost):
	if ((money - structureCost) >= 0):
		money -= structureCost
		get_node("/root/CityMap/HUD/HBoxContainer/Money").text = "$" + comma_values(str(money))
		return true
	else:
		get_node("/root/Overlay").error_pop("Insufficient Funds")
		return false

func calculate_upkeep_costs():
	city_costs = 0
	city_costs += City.numUtilityPlants * UTILITIES_PLANT_UPKEEP_COST
	city_costs += City.numParks * PARK_UPKEEP_COST
	city_costs += City.numRoads * ROAD_UPKEEP_COST
	city_costs += City.numBridges * BRIDGE_UPKEEP_COST
	city_costs += City.numBoardwalks * BOARDWALK_UPKEEP_COST
	city_costs += City.numLibraries * LIBRARY_UPKEEP_COST
	city_costs += City.numMuseums * MUSEUM_UPKEEP_COST
	city_costs += City.numSchools * SCHOOL_UPKEEP_COST
	city_costs += City.numFireStations * FIRE_STATION_UPKEEP_COST
	city_costs += City.numHospital * HOSPITAL_UPKEEP_COST
	city_costs += City.numPoliceStations * POLICE_STATION_UPKEEP_COST
	city_costs += City.numSewageFacilities * SEWAGE_FACILITY_UPKEEP_COST
	city_costs += City.numWasteTreatment * WASTE_TREATMENT_UPKEEP_COST
	city_costs += City.numWaveBreaker * WAVE_BREAKER_UPKEEP_COST
	city_costs += City.numSingleFamilyZones * SINGLE_FAMILY_UPKEEP_COST
	city_costs += City.numMultiFamilyZones * MULTI_FAMILY_UPKEEP_COST
	city_costs += UpdatePopulation.get_population() * UPKEEP_PER_PERSON
	
func updateProfitDisplay():
	var profit = round(city_income - city_costs)
	#get_node("/root/CityMap/HUD/TopBar/HBoxContainer/City_Income").text = "$" + comma_values(str(profit))
	#print("$" + comma_values(str(profit)))
	
func profit():
	var profit = round(city_income - city_costs)
	adjust_player_money(profit)
	var currEvent = Event.new("Profit", "Money Made Each Month", profit)
	Announcer.notify(currEvent)
	currEvent.queue_free()

func calcCityIncome(): #Calculate tax profit
	var taxProfit = 0
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth
	for i in mapHeight:
		for j in mapWidth:
			var currTile = Global.tileMap[i][j]
			taxProfit += currTile.profitRate
	city_income = taxProfit
	return round(taxProfit)

#Made redundant since adjustment on UI is a range bar in dashboard
func adjust_tax_rate(val):
	BASE_TAX_RATE += val
	if (BASE_TAX_RATE < 0):
		BASE_TAX_RATE = 0
	elif (BASE_TAX_RATE > 1):
		BASE_TAX_RATE = 1
	#get_node("/root/CityMap/HUD/TopBar/HBoxContainer/City_Tax_Rate").text = "Tax Rate: " + str(BASE_TAX_RATE * 100) + "%"

#range bar prevents taxes from going over/under 0-100%
func adjust_property_tax_rate(val):
	PROPERTY_TAX = val

func adjust_sales_tax_rate(val):
	SALES_TAX = val
	
func adjust_income_tax_rate(val):
	INCOME_TAX = val

func adjust_individual_tax_rate(num, dir):
	var currRate
	match num:
		0:
			currRate = LIGHT_RES_PROPERTY_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			LIGHT_RES_PROPERTY_RATE = currRate
		1:
			currRate = LIGHT_RES_INCOME_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			LIGHT_RES_INCOME_RATE = currRate
		2:
			currRate = HEAVY_RES_PROPERTY_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			HEAVY_RES_PROPERTY_RATE = currRate
		3:
			currRate = HEAVY_RES_INCOME_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			HEAVY_RES_INCOME_RATE = currRate
		4:
			currRate = COM_PROPERTY_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			COM_PROPERTY_RATE = currRate
		5:
			currRate = COM_INCOME_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			COM_INCOME_RATE = currRate
		6:
			currRate = COM_PROPERTY_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			COM_PROPERTY_RATE = currRate
		7:
			currRate = COM_INCOME_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			COM_INCOME_RATE = currRate
			
func calc_profit_rates():
	var total_income = 0
	var total_profit = 0
	var res_tiles = 0
	var com_tiles = 0
	#update the profit rate for all tiles and calc avg residential income and avg commercial profit
	for x in Global.mapHeight:
		for y in Global.mapWidth:
			if is_valid_tile(x, y):
				var currTile = Global.tileMap[x][y]
				#city profit for res tiles is based on how many people are there and how many houses
				if currTile.is_residential():
					#no workers to pay income tax, so no revenue
					if currTile.data[2] == 0:
						currTile.profitRate = 0
					else:
						currTile.profitRate = (currTile.data[2] * UpdatePopulation.BASE_EMPLOYMENT_RATE * \
						Econ.INCOME_TAX + currTile.data[0] * Econ.PROPERTY_TAX) * \
						Econ.TAX_INCOME_MULTIPLIER * currTile.landValue
					total_income += currTile.profitRate
				#commercial zones generate revenue via sales tax and property tax, 
				#scaling how much sales tax based on the income of their surrounding area
				if currTile.is_commercial():
					#no workers to work, so no revenue from tile
					if currTile.data[2] == 0:
						currTile.profitRate = 0
					else:
						currTile.profitRate = (avg_income_around_tile(currTile.i, currTile.j) * Econ.SALES_TAX) * \
						(UpdatePopulation.get_population() /City.numCommercialZones) + \
						currTile.data[0] * Econ.PROPERTY_TAX * Econ.TAX_INCOME_MULTIPLIER * currTile.landValue
						#the population bit is to help commercial profit scale with population
						# it basically assumes that people will patronize all commercial zones equally
					total_profit += currTile.profitRate
					
	#avg income now represents the average tax revenue from the incomes of the employed people 
	#in the city and the value of the houses where they live
	if (City.numResidentialZones != 0):
		avg_income = total_income / City.numResidentialZones
	#avg_profit represents the average amount of money a commercial tile makes in the city
	if (City.numCommercialZones != 0):
		avg_profit = total_profit / City.numCommercialZones

# Helper Functions
func comma_values(val):
	var res = ""
	#this cuts off the negative sign to allow for proper comma formatting
	if (val[0] == '-'):
		val = val.substr(1, -1)
		# add the negative sign back into the result
		res += "-"
		
	var pos = val.length() % 3
	
	for i in range(0, val.length()):
		if i != 0 && i % 3 == pos:
			res += ","
		res += val[i]
		
	return res

func adjust_individual_tax_rate_helper(currRate, dir):
	if (dir == 0):
		currRate += 0.01
	else:
		currRate -= 0.01
	
	if (currRate < 0):
		currRate = 0
	elif (currRate > 1):
		currRate = 1
	
	return currRate
	
func avg_income_around_tile(i, j):
	var total_income = 0
	var res_tiles = 0
	var local_avg_income = 0
	if is_valid_tile(i, j):
		var tile = Global.tileMap[i][j]
		for x in range(tile.i-1, tile.i+2):
			for y in range(tile.j-1, tile.j+2):
				if is_valid_tile(x, y):
					var currTile = Global.tileMap[x][y]
					if currTile.is_residential():
						var tile_income = (currTile.data[2] * UpdatePopulation.BASE_EMPLOYMENT_RATE * \
						Econ.INCOME_TAX + currTile.data[0] * Econ.PROPERTY_TAX) * \
						Econ.TAX_INCOME_MULTIPLIER * currTile.landValue
						total_income += tile_income
						res_tiles += 1
		if res_tiles != 0:
			local_avg_income = total_income / res_tiles
	return local_avg_income
	
#copied from presence_of_water.gd for use in above function as a helper
func is_valid_tile(i, j) -> bool:
	if i < 0 || Global.mapHeight <= i:
		return false
	if j < 0 || Global.mapWidth <= j:
		return false
	return true
