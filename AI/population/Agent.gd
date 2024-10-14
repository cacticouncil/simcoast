class_name Agent
extends Node
# single population agent

enum JOBS{
	LOW,
	MIDDLE,
	HIGH
}
# tile in which agent lives in
var residential_tile = null
# tile in which agent works in
var commercial_tile = null
# type of job agent can have
var job = JOBS.LOW
# employement status
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
