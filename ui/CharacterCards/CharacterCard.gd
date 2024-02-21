extends VBoxContainer

var greyscale = preload("res://assets/shaders/greyscale.tres")
var charUnlocked

#function updates character values to display in dashboard
func updateValues(characterName, characterDescription, icon, unlocked):
	
	var name = characterName
	#loads character description for hover functionality
	$Icon/Description.text = characterDescription
	charUnlocked = unlocked
	
	$Icon.texture = load(icon)
	if (charUnlocked == false):
		$Icon.material = ShaderMaterial.new()
		$Icon.material.shader = greyscale
		$Name.text = "Unlock character!"
	else:
		$Name.text = characterName

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
