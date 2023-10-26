extends Node

# Called when the node enters the scene tree for the first time.
func set_values(achName, achPic):
	$BG/AchievementName.text = achName
	$BG/TextureRect.set_texture(load(achPic))
