class_name Agent
extends Node
# single population agent

enum JOBS{
	LOW,
	MIDDLE,
	HIGH
}
enum JOB_TYPES {
	LIBRARIAN,
	FIREFIGHTER,
	PARK_RANGER,
	BUSINESS_OWNER,
	BUSINESS_EMPLOYEE,
	UTILITY_PLANT_OPERATOR,
	HOSPITAL_EMPLOYEE,
	POLICE_OFFICER,
	SEWAGE_WORKER,
	WASTE_TREATMENT_WORKER,
	MUSEUM_WORKER,
	SCHOOL_EMPLOYEE,
	TIDE_SCIENTIST,
	RAIN_SCIENTIST,
	WIND_SCIENTIST
}
# tile in which agent lives in
var residential_tile = null
# tile in which agent works in
var commercial_tile = null
# type of job agent can have
var job = JOBS.LOW
# employment status
var hasJob = false

func _init(tile):
	residential_tile = tile
	var r =  randf()
	if r < 0.6:
		job = JOBS.LOW
	elif  r < 0.9:
		job = JOBS.MIDDLE
	else:
		job = JOBS.HIGH
		
func change_job(tile):
	hasJob = true
	commercial_tile = tile
	
func change_residence(tile):
	residential_tile = tile
