extends BTLeaf


var BASE_MOVE_CHANCE = 0.01
var rng = RandomNumberGenerator.new()

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue").pop_front()
	var foundJob = false
	# iterates through the map to find possible working spaces
	# Each utility has a number of jobs as different levels
	# Agents choose higher paying jobs first
	for key in Global.activeTiles:
			if foundJob == false:
				var current_tile = Global.tileMap[key[0]][key[1]]
				#print(current_tile.jobMax)
				if current_tile.jobCapacity < current_tile.jobMax:
					if current_tile.has_utilities() && current_tile.tileDamage == 0:
						if current_tile.is_commercial():
							foundJob = true
							if current_tile.jobCapacity == 0:
								current_agent.level = Agent.JOBS.HIGH
								current_agent.job = Agent.JOB_TYPES.BUSINESS_OWNER
								current_tile.numHighLevelJobs -= 1
							else:
								current_agent.level = Agent.JOBS.LOW
								current_agent.job = Agent.JOB_TYPES.BUSINESS_EMPLOYEE
								current_tile.numLowLevelJobs -= 1
							current_tile.jobCapacity += 1
							current_agent.change_job(current_tile)

						elif current_tile.zone == Tile.TileZone.PUBLIC_WORKS:
							if current_tile.inf == Tile.TileInf.PARK:
								foundJob = true
								current_tile.jobCapacity += 1
								current_tile.numMidLevelJobs -= 1
								current_agent.job = Agent.JOB_TYPES.PARK_RANGER
								current_agent.change_job(current_tile)
								current_agent.level = Agent.JOBS.MIDDLE
							elif current_tile.inf == Tile.TileInf.FIRE_STATION:
								foundJob = true
								if (current_tile.numMidLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.FIRE_CHIEF
									current_agent.level = Agent.JOBS.MIDDLE
									current_tile.jobCapacity += 1
									current_tile.numMidLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.FIREFIGHTER
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.HOSPITAL:
								foundJob = true
								if (current_tile.numHighLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.DOCTOR
									current_agent.level = Agent.JOBS.HIGH
									current_tile.jobCapacity += 1
									current_tile.numHighLevelJobs -= 1
								elif (current_tile.numMidLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.NURSE
									current_agent.level = Agent.JOBS.MIDDLE
									current_tile.jobCapacity += 1
									current_tile.numMidLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.HOSPITAL_EMPLOYEE
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.POLICE_STATION:
								foundJob = true
								if (current_tile.numHighLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.POLICE_CHIEF
									current_agent.level = Agent.JOBS.HIGH
									current_tile.jobCapacity += 1
									current_tile.numHighLevelJobs -= 1
								elif (current_tile.numMidLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.POLICE_DETECTIVE
									current_agent.level = Agent.JOBS.MIDDLE
									current_tile.jobCapacity += 1
									current_tile.numMidLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.POLICE_OFFICER
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.LIBRARY:
								foundJob = true
								if (current_tile.numMidLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.LIBRARIAN
									current_agent.level = Agent.JOBS.MIDDLE
									current_tile.jobCapacity += 1
									current_tile.numMidLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.LIBRARIAN
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.MUSEUM:
								foundJob = true
								if (current_tile.numMidLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.MUSEUM_WORKER
									current_agent.level = Agent.JOBS.MIDDLE
									current_tile.jobCapacity += 1
									current_tile.numMidLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.MUSEUM_WORKER
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.SCHOOL:
								foundJob = true
								if (current_tile.numHighLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.PRINCIPAL
									current_agent.level = Agent.JOBS.HIGH
									current_tile.jobCapacity += 1
									current_tile.numHighLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.TEACHER
									current_agent.level = Agent.JOBS.MIDDLE
									current_tile.jobCapacity += 1
									current_tile.numMidLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.UTILITIES_PLANT:
								foundJob = true
								if (current_tile.numHighLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.UTILITY_PLANT_OPERATOR
									current_agent.level = Agent.JOBS.HIGH
									current_tile.jobCapacity += 1
									current_tile.numHighLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.UTILITY_PLANT_OPERATOR
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.SEWAGE_FACILITY:
								foundJob = true
								if (current_tile.numHighLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.SEWAGE_WORKER
									current_agent.level = Agent.JOBS.HIGH
									current_tile.jobCapacity += 1
									current_tile.numHighLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.SEWAGE_WORKER
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
							elif current_tile.inf == Tile.TileInf.WASTE_TREATMENT:
								foundJob = true
								if (current_tile.numHighLevelJobs != 0):
									current_agent.job = Agent.JOB_TYPES.WASTE_TREATMENT_WORKER
									current_agent.level = Agent.JOBS.HIGH
									current_tile.jobCapacity += 1
									current_tile.numHighLevelJobs -= 1
								else:
									current_agent.job = Agent.JOB_TYPES.WASTE_TREATMENT_WORKER
									current_agent.level = Agent.JOBS.LOW
									current_tile.jobCapacity += 1
									current_tile.numLowLevelJobs -= 1
								current_agent.change_job(current_tile)
					# if living space is suitable and chance of moving allows for move to happen, move agent
					#if (selectTile > rng.randf_range(0, maxRange)):
					#	UpdateAgent.ActiveAgents.find(current_agent).residential_tile = current_tile
					#	moved = true
					#	break
	if foundJob == false:
		#Check beach for jobs
		#Arbitary beach tile
		var beachTile = Global.tileMap[Global.beachRows[0]][1]
		if (UpdateAgent.numBeachManagers != 0):
			current_agent.job = Agent.JOB_TYPES.BEACH_WORKER
			current_agent.level = Agent.JOBS.MIDDLE
			current_agent.change_job(beachTile)
			UpdateAgent.numBeachManagers -= 1
			foundJob = true
		elif (UpdateAgent.numBeachWorkers != 0):
			current_agent.job = Agent.JOB_TYPES.BEACH_WORKER
			current_agent.level = Agent.JOBS.LOW
			current_agent.change_job(beachTile)
			UpdateAgent.numBeachWorkers -= 1
			foundJob = true
	
	if foundJob == true:
		#print("found job", current_agent.commercial_tile.i, current_agent.commercial_tile.j)
		current_agent.unemployed_month = null
		current_agent.months_passed = 0
		UpdateAgent.increase_total_jobs()
	else:
		if current_agent.unemployed_month == null:
			current_agent.unemployed_month = UpdateDate.month
		elif current_agent.unemployed_month != UpdateDate.month:
			current_agent.unemployed_month = UpdateDate.month
			current_agent.months_passed +=1

		if current_agent.months_passed > 6:
			var currTile = current_agent.residential_tile
			currTile.remove_people(1)
			UpdateAgent.ActiveAgents.erase(current_agent)

	# updates queue
	check_empty(blackboard)
	#print("succeeded can_find_job")
	#succeeds, if ticked
	return succeed()

# Checks to see if the last item in the queue was consumed. Stops the AI
func check_empty(blackboard: Blackboard) -> void:
	var empty = blackboard.get_data("queue").empty()
	#print(str("empty",empty))
	if empty:
		blackboard.set_data("queue_empty", true)
