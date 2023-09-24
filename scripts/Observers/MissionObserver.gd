extends "res://scripts/Observers/Observer.gd"
class_name MissionObserver
#Handles Missions, unlike Achievements, these need a sense of progression

# Missions are a list of dictionaries that are individual sets of missions
var missions = [
	{
		'Build 1 Residential Areas': false, 
		'Build 1 Commercial Areas': false
	},
	{
		'Build 5 Residential Areas': false, 
		'Build 5 Commercial Areas': false
	}
]

# Mission index keeps track of which set of mission set we're on
var missionStats = {
	'Mission Index': 0
}

func onNotify(event, stats):
	if missionStats['Mission Index'] == 0:
		checkMissionZero(event, stats)
	elif missionStats['Mission Index'] == 1:
		checkMissionOne(event, stats)

func checkMissionZero(event, stats):
	if stats['# of Residential Areas'] >= 1:
		unlock('Build 1 Residential Areas', 0)
	if stats['# of Commercial Areas'] >= 1:
		unlock('Build 1 Commercial Areas', 0)

func checkMissionOne(event, stats):
	if stats['# of Residential Areas'] >= 5:
		unlock('Build 5 Residential Areas', 0)
	if stats['# of Commercial Areas'] >= 5:
		unlock('Build 5 Commercial Areas', 0)

func unlock(missName, missType):
	var i = missionStats['Mission Index']
	
	# Unlock if it hasn't already been unlocked
	if !missions[i][missName]:
		missions[i][missName] = true
		print("Mission Complete: " + missName)
		
		# Check if all missions in this group our complete
		var groupComplete = true
		for mission in missions[i].values():
			if !mission:
				groupComplete = false
		if groupComplete:
			print("All Missions Complete in Group #" + str(i))
			missionStats['Mission Index'] += 1
		
		#Displays building achievement
		if (missType == 0):
			#Overlay.b_achievement_pop()
			pass
		#Displays economic achievement
		elif (missType == 1):
			#Overlay.e_achievement_pop()
			pass
