extends VBoxContainer


func updateValues(characterName, icon, unlocked):
	var name = characterName
	$Icon.texture = load(icon)
	if (unlocked == false):
		#TO DO: Make grey
		$Icon.self_modulate = Color(1, 1, 1)
	else:
		$Icon.self_modulate = Color(1, 1, 1)
	$Name.text = characterName
