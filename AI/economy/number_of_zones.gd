extends BTLeaf

const ZONE_CAP = 30
const PEOPLE_CAP = 100


# How developed is the city in terms of number of zones and population number?
func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var tile = blackboard.get_data("queue").front()
	var numResidentialZones = 0
	var numCommercialZones = 0
	
	# Count number of zones
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			var current = Global.tileMap[i][j]
			
			if current.is_commercial():
				numCommercialZones += 1
			elif current.is_residential():
				numResidentialZones += 1
					
	
	# Cap the counted values as needed	
	if numCommercialZones > ZONE_CAP:
		numCommercialZones = ZONE_CAP
	if numResidentialZones > ZONE_CAP:
		numResidentialZones = ZONE_CAP
	
	# Set the associated Global values
	Global.numCommercialZones = numCommercialZones
	Global.numResidentialZones = numResidentialZones
	
	return succeed()
