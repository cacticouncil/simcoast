extends Node

func _ready():
	var lockedAch = AchievementObserver.getLockedAchievements()
	var unlockedAch = AchievementObserver.getUnlockedAchievements()
	var container
	
	#If we have no unlocked achivevements, don't write unlocked
	if unlockedAch.size() == 0:
		$ScrollContainer/Achievements/Unlocked.visible = false
	else:
		$ScrollContainer/Achievements/Unlocked.visible = true
	
	for i in range(unlockedAch.size()):
		# We have 3 achievements side by side, then print on the next row
		if i % 3 == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 20)
			$ScrollContainer/Achievements/UnlockedAchievements.add_child(container)
			# This random control node was the easiest way to get the first spacing
			container.add_child(Control.new())
		var Ach = preload("res://ui/SubMenu/Achievement.tscn")
		var AchInstance = Ach.instance()
		
		var currAch = unlockedAch[i]
		AchInstance.updateValues(currAch.achievementName, currAch.achievementDescription, currAch.constGoal, currAch.constGoal, currAch.icon, true)
		
		container.add_child(AchInstance)
	
	if lockedAch.size() == 0:
		$ScrollContainer/Achievements/Locked.visible = false
	else:
		$ScrollContainer/Achievements/Locked.visible = true
	
	for i in range(lockedAch.size()):
		if i % 3 == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 20)
			$ScrollContainer/Achievements/LockedAchievements.add_child(container)
			container.add_child(Control.new())
		var Ach = preload("res://ui/SubMenu/Achievement.tscn")
		var AchInstance = Ach.instance()
		
		var currAch = lockedAch[i]
		var currProgress = Stats.getStat(currAch.varToCheck)
		AchInstance.updateValues(currAch.achievementName, currAch.achievementDescription, currProgress, currAch.constGoal, currAch.icon, false)
		
		container.add_child(AchInstance)



func _on_QuitButton_pressed():
	$QuitButton.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/DashboardSelected").visible = true
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	get_parent().remove_child(self)


func _on_QuitButton_mouse_entered():
	$QuitButton.material.set_shader_param("value", 0.3)


func _on_QuitButton_mouse_exited():
	$QuitButton.material.set_shader_param("value", 1)


func _on_QuitButton_button_down():
	$QuitButton.material.set_shader_param("value", 0.1)
