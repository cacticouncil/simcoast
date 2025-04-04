class_name Agent
extends Node
# single population agent

enum JOBS{
	LOW,
	MIDDLE,
	HIGH
}
enum COL {
	LOW,
	MEDIUM,
	HIGH
}
enum JOB_TYPES {
	BEACH_WORKER
	PRINCIPAL,
	TEACHER
	LIBRARIAN,
	MUSEUM_WORKER,
	FIRE_CHIEF
	FIREFIGHTER,
	PARK_RANGER,
	BUSINESS_OWNER,
	BUSINESS_EMPLOYEE,
	UTILITY_PLANT_OPERATOR,
	DOCTOR,
	NURSE,
	HOSPITAL_EMPLOYEE,
	POLICE_CHIEF,
	POLICE_DETECTIVE
	POLICE_OFFICER,
	SEWAGE_WORKER,
	WASTE_TREATMENT_WORKER,
	TIDE_SCIENTIST,
	RAIN_SCIENTIST,
	WIND_SCIENTIST
}
# tile in which agent lives in
var residential_tile = null
# tile in which agent works in
var commercial_tile = null
# type of job agent can have
var job = null
var level = JOBS.LOW
# employment status
var hasJob = false

var unemployed_month = null
var months_passed = 0

#Economic - monthly costs
#Groceries, other stuff, should be based off of the amount of resource demand
#High resource demand = higher cost of goods_services
var cost_of_goods_services
#Constant value for utilities
var cost_utilities = 400
#Based on desirability of the residential tile at the time of moving in
var cost_of_housing
#Accumulation of all the expenses to the Agent
var cost_of_living = 0
var col_level = COL.LOW

func _init(tile):
	residential_tile = tile
	cost_of_housing = 1500 * range_lerp(tile.desirability, 0, 1, 0, 2)
	update_col()

func change_job(tile):
	removeJob()
	hasJob = true
	commercial_tile = tile

func change_residence(tile):
	print("moved from", residential_tile.i, residential_tile.j)
	print("moved to", tile.i, tile.j)
	residential_tile.remove_people(1)
	residential_tile = tile
	residential_tile.add_people(1)
	cost_of_housing = 1500 * range_lerp(tile.desirability, 0, 1, 0, 2)
	update_col()

func update_col():
	cost_of_goods_services = 300 * range_lerp(residential_tile.cost_goods_services, 0, 1, 0, 2)
	cost_of_living = cost_of_housing + cost_utilities + cost_of_goods_services
	#print(cost_of_living)
	#These thresholds may be tweaked
	if cost_of_living < 1500:
		col_level = COL.LOW
	elif cost_of_living > 2500:
		col_level = COL.HIGH
	else:
		col_level = COL.MEDIUM
func removeJob():
	var currTile = commercial_tile
	if (currTile == null):
		return
	if (job == JOB_TYPES.BEACH_WORKER):
		if (level == JOBS.MIDDLE):
			UpdateAgent.numBeachManagers += 1
		elif (level == JOBS.LOW):
			UpdateAgent.numBeachWorkers += 1
	else:
		if (level == JOBS.LOW):
			currTile.numLowLevelJobs += 1
		elif (level == JOBS.HIGH):
			currTile.numHighLevelJobs += 1
		elif (level == JOBS.MIDDLE):
			currTile.numMidLevelJobs += 1
		currTile.jobCapacity -= 1
		currTile.remove_people(1)
	UpdateAgent.decrease_total_jobs()
	hasJob = false
	commercial_tile = null
