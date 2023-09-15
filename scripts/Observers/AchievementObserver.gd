class_name AchievementObserver extends "res://scripts/Observers/Observer.gd"
#Handles Achievements

var achievements = {'Money Made': false}

func onNotify(event):
	if event.eventName == "Money" && event.eventValue > 110000:
		unlock('Money Made')

func unlock(achName):
	if !achievements[achName]:
		achievements[achName] = true
		print("Achievement Unlocked: " + achName)
		# TODO: Display achievements
