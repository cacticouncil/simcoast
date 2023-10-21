extends Node

var NO_POWER_UNHAPPINESS = 10
var DAMAGE_UNHAPPINESS = 10
var SEVERE_DAMAGE_UNHAPPINESS = 30

func calcResidentialDemand():
	# calc avg happiness of all residential zones
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth
	
	var maxpop = 0
	var currpop = 0
	var resDemand = 0
	var resZones = 0
	var avgleave = 0
	var avgmove = 0
	for i in mapHeight:
		for j in mapWidth:
			var currTile = Global.tileMap[i][j]
			if currTile.zone == Tile.TileZone.LIGHT_RESIDENTIAL || currTile.zone == Tile.TileZone.HEAVY_RESIDENTIAL:
				# calc chance of pop moving in (based on updatePopulation chance)
				avgmove += (currTile.happiness)
				# calc of pop leaving (based on updatePopulation chance)
				if !currTile.is_powered():
					avgleave += NO_POWER_UNHAPPINESS
				if currTile.get_status() == Tile.TileStatus.LIGHT_DAMAGE || currTile.get_status() == Tile.TileStatus.MEDIUM_DAMAGE:
					avgleave += DAMAGE_UNHAPPINESS
				elif currTile.get_status() == Tile.TileStatus.HEAVY_DAMAGE:
					avgleave += SEVERE_DAMAGE_UNHAPPINESS
				if currTile.zone == Tile.TileZone.LIGHT_RESIDENTIAL:
					maxpop += 16
				else:
					maxpop += 16 #TODO may need to be changed if heavy residential zoning is changed
				currpop += currTile.data[2]
				resZones += 1
	if avgleave == 0 && avgmove == 0:
		return 0
	avgleave /= resZones
	avgmove /= resZones
	# if more citizens are leaving than moving in, no demand
	if avgleave > avgmove:
		resDemand = 0
	# otherwise scale demand based on the difference between the two
	else:
		resDemand = round((avgmove - avgleave)/20)
		# ensure minimum demand if at maximum population capacity 
		if maxpop == currpop:
			resDemand += 1
		# cap demand at 10
		if resDemand > 10:
			resDemand = 10
	return resDemand

func calcCommercialDemand():
	var mapHeight = Global.mapHeight
	var mapWidth = Global.mapWidth
	
	var comDemand = 0
	var pop = 0;
	var comzones = 0;
	# get population and number of commercial zones, Heavy Commercial weighted double 
	for i in mapHeight:
		for j in mapWidth:
			var currTile = Global.tileMap[i][j]
			if currTile.zone == Tile.TileZone.HEAVY_RESIDENTIAL:
				pop += currTile.data[2]
			elif currTile.zone == Tile.TileZone.LIGHT_RESIDENTIAL:
				pop += currTile.data[2]
			elif currTile.zone == Tile.TileZone.HEAVY_COMMERCIAL:
				comzones += 2
			elif currTile.zone == Tile.TileZone.LIGHT_COMMERCIAL:
				comzones += 1
	# for every 48 residential pop (3 full residential zones), demand 1 commercial zone
	comDemand = round(pop/48)
	comDemand -= comzones
	# Don't accept negative demand
	if comDemand < 0:
		comDemand = 0;
	return comDemand
	
func get_demand():
	var resDemand = 0
	var comDemand = 0
	resDemand = calcResidentialDemand()
	comDemand = calcCommercialDemand()
	#get_node("/root/CityMap/HUD/TopBar/HBoxContainer/Demand").text = "Residential Demand: " + str(resDemand) + "/10" + " Commercial Demand: " + str(comDemand) + "/10"
	return
