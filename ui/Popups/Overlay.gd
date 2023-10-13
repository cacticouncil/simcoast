extends CanvasLayer

#Source - https://www.youtube.com/watch?v=rJcy221LrYs

#Calls to popup animation in Overlay scene
func achievement_pop(achName):
	get_node("/root/Overlay/Achievement/Empty Sprite/AchievementName").text = achName
	$Achievement/AnimationPlayer.play("popup")
