extends Node

const WEIGHTS = {
	"high_traffic": 1.2,
	"medium_traffic": 1.0,
	"low_traffic": 0.8
}
var TOURIST_CHANCE = 0.5
var LOWER_BOUND = 0.0
var UPPER_BOUND = 1.0

var traffic = 0.5
#This will be a percentage
var beach_attractiveness
var beach_cols
var top_beach_row
var rng = RandomNumberGenerator.new()
#Based off of the time of year, beach attractiveness, and whether the beach is closed, 
#calculate the percentage chance of tourists coming in
func _ready():
	pass
#This is the percentage chance of tourists being added in
#This function should be called once a week
func update_tourism():
	top_beach_row = Global.beachRows[0]
	beach_cols = Global.mapWidth - 1
	#If Beach is evacuated, no tourists should be visiting
	if Global.beginBeachEvacuation || Global.stayEvacuated:
		TOURIST_CHANCE = 0
	else:
		#Update Beach attractiveness, turning into percentage
		beach_attractiveness = Beach.calculate_attractivness() / 100.0
		#Calculate traffic based on the current month
		match int(UpdateDate.month):
			1, 2, 3:
				traffic = WEIGHTS.medium_traffic
			4, 5, 6, 7:
				traffic = WEIGHTS.high_traffic
			8, 9, 10, 11, 0:
				traffic = WEIGHTS.low_traffic
		#Calculate chance based on attractiveness and traffic
		TOURIST_CHANCE = traffic * beach_attractiveness
		TOURIST_CHANCE = clamp(TOURIST_CHANCE, LOWER_BOUND, UPPER_BOUND)
	update_beach_tiles()
	return TOURIST_CHANCE
#Updates the beach tiles adding in tourists
func update_beach_tiles():
	#rng.randomize()
	#Should clear tourists weekly
	#Max amount of tourist agents is amount of commercial zones
	#Upper bounded by population, and percentage of population
	#Add in changing location for tourists
	
	var maxTourists = UpdatePopulation.get_population()
	var numTourists = int(maxTourists * TOURIST_CHANCE)
	UpdateTourist.clear_tourists()
	for i in numTourists:
		UpdateTourist.add_tourist(top_beach_row, beach_cols)
