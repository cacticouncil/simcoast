extends Node

const WEIGHTS = {
	"high_traffic": 0.9,
	"medium_traffic": 0.6,
	"low_traffic": 0.2
}
var TOURIST_CHANCE = 0.5
var LOWER_BOUND = 0.0
var UPPER_BOUND = 1.0
#var num_of_toursists = 0
#City damage will impact Tourism
var traffic = 0.5
#This will be a percentage
#Beach.calculate_attractiveness()
#Make sure to clamp attractiveness to be between 0 and 1.0
var beach_attractiveness
var top_beach_row = 10
var top_beach_cols = 16
var rng = RandomNumberGenerator.new()
#var total_tourists = 0
#Calculate percentage chance of tourists, and that is how many are assigned per tile
#Then can calculate total number of tourists from there across those tiles
#Based off of the time of year, beach attractiveness, and whether the beach is closed, calculate the percetnage chance of tourists that can
#be applied to each tile, tourists will be an attribute of beach tiles
#The beach has a certain percentage chance of tourists

#This is the percentage chance of tourists being added in
#This function should be called once a week
func update_tourism():
	#total_tourists = 0
	#If Beach is evacuated, no tourists should be visiting
	if Global.beginBeachEvacuation || Global.stayEvacuated:
		TOURIST_CHANCE = 0
	else:
		#Update Beach attractiveness, turning into percentage
		#beach_attractiveness = Beach.attractiveness / 100.0
		beach_attractiveness = 0.5
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
	#print(TOURIST_CHANCE)
	update_beach_tiles()
	#print(total_tourists)
	return TOURIST_CHANCE
#Updates the beach tiles adding in tourists
func update_beach_tiles():
	rng.randomize()
	for j in range(top_beach_cols):
		var beachTile = Global.tileMap[top_beach_row][j]
		#Should clear any left over tourists
		beachTile.clear_tourists()
		#Add a tourist based on chance
		if (TOURIST_CHANCE > rng.randf()):
			beachTile.add_tourists(1)
			#total_tourists += 1