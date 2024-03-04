extends VBoxContainer

#Character cards display in dashboard under "field professionals".
#This script is used to create character cards and their functionality.
#Hovering over character cards displays the character's information (see mouse entered/exit functions).
#If character is locked, hovering displays lock symbol (that I drew on procreate, its a bit jankey)

var greyscale = preload("res://assets/shaders/greyscale.tres")
var charUnlocked

#function updates character values to display in dashboard
func updateValues(characterName, characterDescription, icon, unlocked):
	
	var name = characterName
	#loads character description for hover functionality
	$Icon/Description.text = characterDescription
	charUnlocked = unlocked
	
	$Icon.texture = load(icon)
	#Makes icon greyscale if character hasn't been unlocked
	if (charUnlocked == false):
		$Icon.material = ShaderMaterial.new()
		$Icon.material.shader = greyscale
		$Name.text = "Unlock character!"
	else:
		$Name.text = characterName

#Hover functions to implement dynamic character information.
func _on_Icon_mouse_entered():
	$Icon.self_modulate = Color(0.3, 0.3, 0.3)
	if (charUnlocked == false):
		$Icon/Lock.visible = true
	else:
		$Icon/Description.visible = true

func _on_Icon_mouse_exited():
	$Icon.self_modulate = Color(1, 1, 1)
	if (charUnlocked == false):
		$Icon/Lock.visible = false
	else:
		$Icon/Description.visible = false
