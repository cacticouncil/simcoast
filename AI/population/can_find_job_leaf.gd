extends BTLeaf


var BASE_MOVE_CHANCE = 0.01
var rng = RandomNumberGenerator.new()

func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var current_agent = blackboard.get_data("queue").pop_front()
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth
	var foundJob = false
	# iterates through the map to find possible working spaces
	for key in Global.activeTiles:
			if foundJob == false:
				var current_tile = Global.tileMap[key[0]][key[1]]
				#print(current_tile.jobMax)
				if current_tile.jobCapacity < current_tile.jobMax:
					if current_tile.has_utilities() && current_tile.tileDamage == 0:
						if current_tile.zone == Tile.TileZone.COMMERCIAL:
							foundJob = true
							if current_tile.jobCapacity == 0:
								current_agent.level = Agent.JOBS.HIGH
								current_agent.job = Agent.JOB_TYPES.BUSINESS_OWNER
							else:
								current_agent.job_level()
								current_agent.job = Agent.JOB_TYPES.BUSINESS_EMPLOYEE
							current_tile.jobCapacity += 1
							current_agent.change_job(current_tile)

						elif current_tile.zone == Tile.TileZone.PUBLIC_WORKS:
							if current_tile.inf == Tile.TileInf.PARK:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.PARK_RANGER
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.FIRE_STATION:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.FIREFIGHTER
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.HOSPITAL:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.HOSPITAL_EMPLOYEE
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.POLICE_STATION:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.POLICE_OFFICER
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.LIBRARY:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.LIBRARIAN
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.MUSEUM:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.MUSEUM_WORKER
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.SCHOOL:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.SCHOOL_EMPLOYEE
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.UTILITIES_PLANT:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.UTILITY_PLANT_OPERATOR
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.SEWAGE_FACILITY:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.SEWAGE_WORKER
								current_agent.change_job(current_tile)
								current_agent.job_level()
							elif current_tile.inf == Tile.TileInf.WASTE_TREATMENT:
								foundJob = true
								current_tile.jobCapacity += 1
								current_agent.job = Agent.JOB_TYPES.WASTE_TREATMENT_WORKER
								current_agent.change_job(current_tile)
								current_agent.job_level()
					# if living space is suitable and chance of moving allows for move to happen, move agent
					#if (selectTile > rng.randf_range(0, maxRange)):
					#	UpdateAgent.ActiveAgents.find(current_agent).residential_tile = current_tile
					#	moved = true
					#	break
	if foundJob == true:
		print("found job")
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
