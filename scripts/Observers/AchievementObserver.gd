class_name AchievementObserver extends "res://scripts/Observers/Observer.gd"
#Handles Achievements

var achievements = {
	'Money Made': false, 
	'Build 10 Residential Areas': false, 
	'Build 10 Commercial Areas': false
}
var stats = {
	'# of Residential Areas': 0, 
	'# of Commercial Areas': 0
}

func onNotify(event):
	if event.eventName == "Added Tile":
		if event.eventDescription == "Added Resedential Area":
			stats['# of Residential Areas'] += event.eventValue
			if stats['# of Residential Areas'] >= 10:
				unlock('Build 10 Residential Areas')
		elif event.eventDescription == "Added Commercial Area":
			stats['# of Commercial Areas'] += event.eventValue
			if stats['# of Commercial Areas'] >= 10:
				unlock('Build 10 Commercial Areas')
	elif event.eventName == "Removed Tile":
		if event.eventDescription == "Removed Residential Area":
			stats['# of Residential Areas'] -= event.eventValue
		elif event.eventDescription == "Removed Commercial Area":
			stats['# of Commercial Areas'] -= event.eventValue
	elif event.eventName == "Money" && event.eventValue > 110000:
		unlock('Money Made')

func unlock(achName):
	if !achievements[achName]:
		achievements[achName] = true
		print("Achievement Unlocked: " + achName)
		# TODO: Display achievements
