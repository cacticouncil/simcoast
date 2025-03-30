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
	LIBRARIAN,#1 max
	FIREFIGHTER,# 4 max
	PARK_RANGER, # 1 max
	BUSINESS_OWNER, #1 max
	BUSINESS_EMPLOYEE, #15 max
	UTILITY_PLANT_OPERATOR,#2 max
	HOSPITAL_EMPLOYEE, #8 max
	POLICE_OFFICER, #4 max
	SEWAGE_WORKER, #2 max
	WASTE_TREATMENT_WORKER, #2 max
	MUSEUM_WORKER, #1 max
	SCHOOL_EMPLOYEE, #8 max
	TIDE_SCIENTIST, #1 max
	RAIN_SCIENTIST, #1 max
	WIND_SCIENTIST #1 max
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
var cost_of_goods_services = 200
#Constant value for utilities
var cost_utilities = 400
#Based on desirability of the residential tile at the time of moving in
var cost_of_housing
#Accumulation of all the expenses to the Agent
var cost_of_living

func _init(tile):
	residential_tile = tile

func change_job(tile):
	hasJob = true
	commercial_tile = tile

func job_level():
	var r =  randf()
	if r < 0.6:
		level = JOBS.LOW
	elif  r < 0.9:
		level = JOBS.MIDDLE
	else:
		level = JOBS.HIGH

func change_residence(tile):
	residential_tile = tile
