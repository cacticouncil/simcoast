extends BTLeaf

const ZONE_CAP = 30
const PEOPLE_CAP = 100


# How developed is the city in terms of number of zones and population number?
func _tick(agent: Node, blackboard: Blackboard) -> bool:
	var tile = blackboard.get_data("queue").front()
	var numResidentialZones = 0
	var numSingleFamily = 0
	var numMultiFamily = 0
	var numCommercialZones = 0
	
	# Count number of zones
	for i in Global.mapHeight:
		for j in Global.mapWidth:
			var current = Global.tileMap[i][j]
			match current.get_zone():
				Tile.TileZone.SINGLE_FAMILY:
					numSingleFamily += 1
				Tile.TileZone.MULTI_FAMILY:
					numMultiFamily += 1
				Tile.TileZone.COMMERCIAL:
					numCommercialZones += 1
					
	numResidentialZones = numSingleFamily + numMultiFamily
	# Cap the counted values as needed	
	if numCommercialZones > ZONE_CAP:
		numCommercialZones = ZONE_CAP
	if numResidentialZones > ZONE_CAP:
		numResidentialZones = ZONE_CAP
	
	# Set the associated Global values
	City.numCommercialZones = numCommercialZones
	City.numResidentialZones = numResidentialZones
	City.numSingleFamilyZones = numSingleFamily
	City.numMultiFamilyZones = numMultiFamily
	
	return succeed()
