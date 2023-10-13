extends CanvasLayer

#Source - https://www.youtube.com/watch?v=rJcy221LrYs

#Calls to popup animation in Overlay scene
func achievement_pop(achName):
	$Achievement/EmptySprite/AchievementName.text = achName
	$Achievement/AnimationPlayer.play("popup")

func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().remove_child(self)
