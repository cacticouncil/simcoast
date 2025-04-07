extends Node

const WEIGHTS = {
	"high_traffic": 1.2,
	"medium_traffic": 1.0,
	"low_traffic": 0.8
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
var beach_cols
var top_beach_row
var rng = RandomNumberGenerator.new()
#Calculate percentage chance of tourists, and that is how many are assigned per tile
#Then can calculate total number of tourists from there across those tiles
#Based off of the time of year, beach attractiveness, and whether the beach is closed, calculate the percetnage chance of tourists that can
#be applied to each tile, tourists will be an attribute of beach tiles
#The beach has a certain percentage chance of tourists
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
		#beach_attractiveness = Beach.attractiveness / 100.0
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
		#print("Beach attractiveness: ", beach_attractiveness)
		TOURIST_CHANCE = traffic * beach_attractiveness
		#print("Number of pop: ", UpdatePopulation.get_population())
		#Bound by population, commercial areas, put in trash level into beach attractiveness
		#If no commercial areas or no population, tourists should be zero
		#If trash level is too high tourists should be zero
		#Implement them moving to a commercial zone tile if beach is evacuated
		#Aggregate trash 
		TOURIST_CHANCE = clamp(TOURIST_CHANCE, LOWER_BOUND, UPPER_BOUND)
	#print("Tourist chance", TOURIST_CHANCE)
	update_beach_tiles()
	#print("Number of tourists: ", UpdateTourist.total_agents())
	return TOURIST_CHANCE
#Updates the beach tiles adding in tourists
func update_beach_tiles():
	#rng.randomize()
	#Should clear tourists weekly
	#Max amount of tourist agents is amount of commercial zones
	#Upper bounded by population, and percentage of population
	#Add in changing location for tourists
	
	var maxTourists = UpdatePopulation.get_population()
	#print("TOURIST_CHANCE", TOURIST_CHANCE)
	var numTourists = int(maxTourists * TOURIST_CHANCE)
	UpdateTourist.clear_tourists()
	for i in numTourists:
		UpdateTourist.add_tourist(top_beach_row, beach_cols)
	#for j in range(beach_cols):
		#var beachTile = Global.tileMap[top_beach_row][j]
		#Should clear any left over tourists
		#beachTile.clear_tourists()
		#Add a tourist based on chance
		#if (TOURIST_CHANCE > rng.randf() && UpdateTourist.total_agents() < maxTourists):
			#break
			#UpdateTourist.add_tourist(top_beach_row, j)
			#beachTile.add_tourists(1)
			#total_tourists += 1
