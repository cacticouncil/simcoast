extends Node


const WEIGHTS = {
	"building": 1.0,
	"single_family": 0.7,
	"boardwalk": 0.4,
	"wave_breaker": 0.7,
	"rock": 0.3,
	
	# decreases beach attractiveness
	"multi_family": -1,
	"trash": -0.6,
	"public_works": -1.5
}

var item_counts = {
	"building": 0,
	"single_family": 0,
	"multi_family": 0,
	"boardwalk": 0,
	"wave_breaker": 0,
	"rock": 0,
	"trash": 0,
	"public_works": 0
}

var base_attractiveness = 5.0
var max_attractiveness = 95.0
var min_attractiveness = 5.0
var scaling_factor = 2

var beach_rows = [10, 16]
var beach_cols = 16

func _ready():
	pass

func update_counts():
	# Reset item counts to zero
	for item in item_counts:
		item_counts[item] = 0

	for i in range(beach_rows[0], beach_rows[1] + 1):
		for j in range(beach_cols):
			var beachTile = Global.tileMap[i][j]
			if beachTile.inf == Tile.TileInf.BEACH_ROCKS || beachTile.inf == Tile.TileInf.BEACH_GRASS:
				item_counts["rock"] += 1
			
			elif beachTile.inf == Tile.TileInf.BOARDWALK:
				item_counts["boardwalk"] += 1
			
			elif beachTile.inf == Tile.TileInf.BUILDING || beachTile.zone == Tile.TileZone.COMMERCIAL:
				item_counts["building"] += 1
			
			elif beachTile.inf == Tile.TileInf.WAVE_BREAKER:
				item_counts["wave_breaker"] += 1
				
			elif beachTile.zone == Tile.TileZone.SINGLE_FAMILY:
				item_counts["single_family"] += 1
				
			elif beachTile.zone == Tile.TileZone.MULTI_FAMILY:
				item_counts["multi_family"] += 1
	
			elif beachTile.zone == Tile.TileZone.PUBLIC_WORKS:
				item_counts["public_works"] += 1
	
	print(calculate_attractivness())
	
func calculate_attractivness():
	var total_impact = 0.0

	# Sum of item count * item weight
	for item in item_counts:
		if item in WEIGHTS:
			var count = item_counts[item]
			var weight = WEIGHTS[item]
			if count > 0:
				for i in range(1, count+1):
					var value = weight * (-i/4+4) # weight * scaling factor for that item
					total_impact += value
	
	var attractiveness = base_attractiveness + total_impact
	
	return clamp(attractiveness, min_attractiveness, max_attractiveness)
