extends VBoxContainer

#Character cards display in dashboard under "field professionals".
#This script is used to create character cards and their functionality.
#Hovering over character cards displays the character's information (see mouse entered/exit functions).
#If character is locked, hovering displays lock symbol (that I drew on procreate, its a bit jankey)

var currCharacter
signal dict_changed(dict)
#function updates character values to display in dashboard
func updateValues(character):
	$contact/name.text = character.name
	$contact/job.text = character.name
	#var picPath = "res://assets/office/"+character.name+".png"
	#$contact/picture.texture = load(picPath)
	currCharacter = character

func _on_contact_pressed():
	currCharacter.ring = true
	#emit_signal("dict_changed", currCharacter)
	SceneManager.emit_signal("phone_npc_clicked", currCharacter)
