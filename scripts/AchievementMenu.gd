extends Node

func _ready():
	print("Achievement Menu Setup")
	var lockedAch = AchievementObserver.getLockedAchievements()
	var unlockedAch = AchievementObserver.getUnlockedAchievements()
	var container
	
	if unlockedAch.size() == 0:
		$ScrollContainer/Achievements/Unlocked.visible = false
	else:
		$ScrollContainer/Achievements/Unlocked.visible = true
	
	for i in range(unlockedAch.size()):
		if i % 3 == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 20)
			$ScrollContainer/Achievements/UnlockedAchievements.add_child(container)
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
	get_parent().remove_child(self)
