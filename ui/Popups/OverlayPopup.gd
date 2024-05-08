extends Node

# Called when the node enters the scene tree for the first time.
func set_values(achName, achPic):
	$BG/AchievementName.text = achName
	$BG/TextureRect.set_texture(load(achPic))

func set_warning(wName, pic, color):
	$BG/WarningName.text = wName
	$BG/TextureRect.set_texture(load(pic))
	$BG/WarningTitle.add_color_override("font_color", Color(color))
