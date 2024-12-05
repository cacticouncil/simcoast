extends Node

# Called when the node enters the scene tree for the first time.
func set_values(npcName, npcPic):
	$BG/CharacterName.text = npcName
	$BG/TextureRect.set_texture(load(npcPic))
