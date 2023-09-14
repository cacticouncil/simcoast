class_name AchievementObserver extends "res://scripts/Observers/Observer.gd"
#Handles Achievements

var MoneyMade = false

func onNotify(event):
	if event == "Money Made":
		unlock(event, MoneyMade)

func unlock(achName, achievement):
	if !achievement:
		achievement = true
		print("Achievement Unlocked: " + achName)
		# TODO: Display achievements
