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
var LIGHT_COM_PROPERTY_RATE = BASE_TAX_RATE #land value * num buildings
var LIGHT_COM_INCOME_RATE = BASE_TAX_RATE #land value * num people
var HEAVY_COM_PROPERTY_RATE = BASE_TAX_RATE #land value * num buildings
var HEAVY_COM_INCOME_RATE = BASE_TAX_RATE #land value * num people

const PROPERTY_TAX = 0.01 #property tax gets set at 1% to start, which is neutral
const SALES_TAX = 0.05 #5% sales tax to start, also neutral
const INCOME_TAX = 0.025 #2.5% income tax, also neutral
#neutrality is from desirability, meaning these taxes are neither light nor heavy

# Tile Durability Constants
const REMOVE_BUILDING_DAMAGE = 0.2
const REMOVE_COMMERCIAL_BUILDING  = 0.3

#Building costs
const UTILITIES_PLANT_COST = 10000
const PARK_COST = 500
const ROAD_COST = 100

#Building upkeep costs
const UTILITIES_PLANT_UPKEEP_COST = 100
const PARK_UPKEEP_COST = 10
const ROAD_UPKEEP_COST = 2

# Player/Mayor Constants
var money = 100000

#Income and costs
var city_income = 0 # Net Profit
var city_costs = 0 # Upkeep costs
var avg_income = 0 #avg income of a res tile
var avg_profit = 0 #avg profit of a commercial tile
#Probably not needed
var city_tax_rate = BASE_TAX_RATE
var property_tax_rate = 0.01 

# adjustVal parameter takes in the exact amount loss or gain towards the player money 
# EX: if player spends $500 then adjustVal should be -500
func adjust_player_money(adjustVal):
	money += adjustVal
	Announcer.notify(Event.new("Money", "Amount of money", money))
	get_node("/root/CityMap/HUD/TopBar/HBoxContainer/Money").text = "$" + comma_values(str(money))

func purchase_structure(structureCost):
	if ((money - structureCost) >= 0):
		money -= structureCost
		get_node("/root/CityMap/HUD/TopBar/HBoxContainer/Money").text = "$" + comma_values(str(money))
		return true
	else:
		return false

func calculate_upkeep_costs():
	city_costs = ((City.numUtilityPlants * UTILITIES_PLANT_UPKEEP_COST) + (City.numParks * PARK_UPKEEP_COST) + (City.numRoads * ROAD_UPKEEP_COST))
	
func updateProfitDisplay():
	var profit = round(city_income - city_costs)
	get_node("/root/CityMap/HUD/TopBar/HBoxContainer/City_Income").text = "$" + comma_values(str(profit))
	#print("$" + comma_values(str(profit)))
	
func profit():
	var profit = round(city_income - city_costs)
	adjust_player_money(profit)
	Announcer.notify(Event.new("Profit", "Money Made Each Month", profit))

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

func adjust_tax_rate(val):
	BASE_TAX_RATE += val
	if (BASE_TAX_RATE < 0):
		BASE_TAX_RATE = 0
	elif (BASE_TAX_RATE > 1):
		BASE_TAX_RATE = 1
	get_node("/root/CityMap/HUD/TopBar/HBoxContainer/City_Tax_Rate").text = "Tax Rate: " + str(BASE_TAX_RATE * 100) + "%"

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
			currRate = LIGHT_COM_PROPERTY_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			LIGHT_COM_PROPERTY_RATE = currRate
		5:
			currRate = LIGHT_COM_INCOME_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			LIGHT_COM_INCOME_RATE = currRate
		6:
			currRate = HEAVY_COM_PROPERTY_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			HEAVY_COM_PROPERTY_RATE = currRate
		7:
			currRate = HEAVY_COM_INCOME_RATE
			currRate = adjust_individual_tax_rate_helper(currRate, dir)
			HEAVY_COM_INCOME_RATE = currRate
			
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
					print("res: ", currTile.profitRate)
					res_tiles += 1
				#commercial zones generate revenue via sales tax and property tax, 
				#scaling how much sales tax based on the income of their surrounding area
				if currTile.is_commercial():
					#no workers to work, so no revenue from tile
					if currTile.data[2] == 0:
						currTile.profitRate = 0
					else:
						currTile.profitRate = (avg_income_around_tile(currTile.i, currTile.j) * Econ.SALES_TAX) * \
						(UpdatePopulation.get_population() / Global.numCommercialZones) + \
						currTile.data[0] * Econ.PROPERTY_TAX * Econ.TAX_INCOME_MULTIPLIER * currTile.landValue
						#the population bit is to help commercial profit scale with population
						# it basically assumes that people will patronize all commercial zones equally
					total_profit += currTile.profitRate
					print("com: ", currTile.profitRate)
					com_tiles += 1
					
	#avg income now represents the average tax revenue from the incomes of the employed people 
	#in the city and the value of the houses where they live
	if (res_tiles != 0):
		avg_income = total_income / res_tiles
	#avg_profit represents the average amount of money a commercial tile makes in the city
	if (com_tiles != 0):
		avg_profit = total_profit / com_tiles

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
