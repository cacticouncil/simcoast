extends TextureRect

# Tier is an int, 0 = bronze, 1 = silver, 2 = gold
func updateValues(icon, tier):
	texture = load(icon)
	if tier == 0:
		self_modulate = Color("ffff7200") #Bronze
	elif tier == 1:
		self_modulate = Color("ffd3d3d3") #Silver
	elif tier == 2:
		self_modulate = Color("ffffbf00") #Gold
