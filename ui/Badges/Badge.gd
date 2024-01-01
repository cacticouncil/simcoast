extends VBoxContainer

# Tier is an int, 0 = bronze, 1 = silver, 2 = gold
func updateValues(badgeName, icon, tier):
	var text = " in " + badgeName
	$Icon.texture = load(icon)
	if tier == 0:
		$Icon.self_modulate = Color("ffff7200") #Bronze
		text = "Bronze Badge" + text
	elif tier == 1:
		$Icon.self_modulate = Color("ffd3d3d3") #Silver
		text = "Silver Badge" + text
	elif tier == 2:
		$Icon.self_modulate = Color("ffffbf00") #Gold
		text = "Gold Badge" + text
	$Description.text = text
