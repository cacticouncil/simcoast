extends Node

var greyscale = preload("res://assets/shaders/greyscale.tres")

func updateValues(aName, aDesc, aValue, aConst, aPic, completed):
	$AchievementName.text = aName
	$AchievementDescription.text = aDesc
	# Multiply width of progress bar by a factor of how close we are to finishing the mission
	$ProgressBarFilled.set_size(Vector2(248 * (float(aValue)/float(aConst)), 15))
	$ProgressNumber.text = str(aValue) + "/" + str(aConst)
	
	$TextureRect.set_texture(load(aPic))
	if !completed:
		$TextureRect.material = ShaderMaterial.new()
		$TextureRect.material.shader = greyscale
