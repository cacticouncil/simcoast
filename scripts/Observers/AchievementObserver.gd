class_name AchievementObserver extends "res://scripts/Observers/Observer.gd"
#Handles Achievements

# TO DO: More properties for achievements (e.g. types, names)
# The reason these are dictionaries instead of vars is persistence issues
var achievements = {
	'Money Made': false, 
	'Build 10 Residential Areas': false, 
	'Build 10 Commercial Areas': false
}

func onNotify(event, stats):
	if stats['# of Residential Areas'] >= 10:
		unlock('Build 10 Residential Areas', 0)
	if stats['# of Commercial Areas'] >= 10:
		unlock('Build 10 Commercial Areas', 0)
	if event.eventName == "Money" && event.eventValue > 110000:
		unlock('Money Made', 1)

func unlock(achName, achType):
	if !achievements[achName]:
		achievements[achName] = true
		print("Achievement Unlocked: " + achName)
		# TODO: Display achievements
		#Displays building achievement
		if (achType == 0):
			Overlay.b_achievement_pop()
		#Displays economic achievement
		elif (achType == 1):
			Overlay.e_achievement_pop()
	
	
