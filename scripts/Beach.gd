extends Node


const WEIGHTS = {
	"building": 1.0,
	"house": 0.6,
	"boardwalk": 0.3,
	"rock": -0.6,
	"trash": -0.3
}

var item_counts = {
	"building": 8,
	"house": 15,
	"boardwalk": 10,
	"rock": 12,
	"trash": 5
}

var base_attractiveness = 50.0
var max_attractiveness = 95.0
var min_attractiveness = 10.0
var scaling_factor = 0.1

var beach_rows = [11, 16]
var beach_cols = 16

func _ready():
	var final_attractiveness = calculate_attract()
	print("Final Beach Attractiveness: ", final_attractiveness, "%")
	print("here")

func update_counts():
	for i in range(beach_rows[0], beach_rows[1] + 1):
		for j in range(beach_cols):
			var beachTile = Global.tileMap[i][j]
			if beachTile.inf == Tile.TileInf.BEACH_ROCKS || beachTile.inf == Tile.TileInf.BEACH_ROCKS:
				item_counts["rock"] += 1
			
			elif beachTile.inf == Tile.TileInf.BOARDWALK:
				item_counts["boardwalk"] += 1
			
			elif beachTile.inf == Tile.TileInf.BUILDING:
				item_counts["building"] += 1
			
			
func calculate_attract():
	var total_impact = 0.0

	# Sum of item count * item weight
	for item in item_counts:
		if item in WEIGHTS:
			total_impact += item_counts[item] * WEIGHTS[item]
	
	var adjusted_impact = total_impact * scaling_factor
	
	var attractiveness = base_attractiveness + adjusted_impact
	print(clamp(attractiveness, min_attractiveness, max_attractiveness))
	return clamp(attractiveness, min_attractiveness, max_attractiveness)
