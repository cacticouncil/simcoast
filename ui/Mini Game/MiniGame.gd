extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_QuitMiniGame_pressed():
	get_parent().remove_child(self)

func _on_QuitMiniGame_button_down():
	$Beach/QuitMiniGame.material.set_shader_param("value", 0.1)

func _on_QuitMiniGame_mouse_entered():
	$Beach/QuitMiniGame.material.set_shader_param("value", 0.3)

func _on_QuitMiniGame_mouse_exited():
	$Beach/QuitMiniGame.material.set_shader_param("value", 1)

func _on_FoodWaste_area_entered(area):
	$Beach/FoodWaste/FWTexture.material.set_shader_param("enable", true)

func _on_FoodWaste_area_exited(area):
	$Beach/FoodWaste/FWTexture.material.set_shader_param("enable", false)


func _on_RecyclingBin_area_entered(area):
	$Beach/RecyclingBin/RBTexture.material.set_shader_param("enable", true)


func _on_RecyclingBin_area_exited(area):
	$Beach/RecyclingBin/RBTexture.material.set_shader_param("enable", false)


func _on_TrashBin_area_entered(area):
	$Beach/TrashBin/TBTexture.material.set_shader_param("enable", true)


func _on_TrashBin_area_exited(area):
	$Beach/TrashBin/TBTexture.material.set_shader_param("enable", false)
