extends CanvasLayer

#Source - https://www.youtube.com/watch?v=rJcy221LrYs

#Calls to popup animation in Overlay scene
func b_achievement_pop():
	$BuildingAchievement/AnimationPlayer.play("popup")
func e_achievement_pop():
	$EconAchievement/AnimationPlayer.play("popup")
