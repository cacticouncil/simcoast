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

var base_attractiveness = 50.0
var max_attractiveness = 95.0
var min_attractiveness = 10.0
var scaling_factor = 1.25

var beach_rows = [10, 16]
var beach_cols = 16

func _ready():
	update_counts()

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
			total_impact += item_counts[item] * WEIGHTS[item]
	
	var adjusted_impact = total_impact * scaling_factor
	
	var attractiveness = base_attractiveness + adjusted_impact
	
	return clamp(attractiveness, min_attractiveness, max_attractiveness)
