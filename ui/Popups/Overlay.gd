extends CanvasLayer

#Source - https://www.youtube.com/watch?v=rJcy221LrYs

#Calls to popup animation in Overlay scene
func achievement_pop(achName, achPic):
	$BG/AchievementName.text = achName
	$BG/TextureRect.set_texture(load(achPic))
	# Made a sick fade animation
	$AnimationPlayer.play("Fade")

func _on_AnimationPlayer_animation_finished():
	#FIXME: Why is this not getting called once the animation finishes?
	get_parent().remove_child(self)
