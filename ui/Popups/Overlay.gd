extends CanvasLayer

#Source - https://www.youtube.com/watch?v=rJcy221LrYs

#Calls to popup animation in Overlay scene
func achievement_pop(achName, achPic):
	print("achiveev")
	$BG/AchievementName.text = achName
	$BG/TextureRect.set_texture(load(achPic))
	$AnimationPlayer.play("Fade")

func _on_AnimationPlayer_animation_finished():
	get_parent().remove_child(self)
