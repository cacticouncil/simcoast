extends "res://scripts/Observers/Observer.gd"
#Handles Missions, unlike Achievements, these need a sense of progression

# Missions are a list of dictionaries that are individual sets of missions
"""
var missions = [
	{
		'Build 1 Residential Area': false, 
		'Build 1 Commercial Area': false
	},
	{
		'Build 5 Residential Areas': false, 
		'Build 5 Commercial Areas': false,
		'Mission 3': false
	}
]
"""
var missions = []

var toDelete = []

# Mission index keeps track of which set of mission set we're on
var missionIndex = 0

func createMissions():
	var goalClass = load("res://scripts/Observers/Goal.gd")
	
	var mission1 = []
	mission1.append(goalClass.new('# of Residential Areas', true, 1, 'Build 1 Residential Area', 'Build 1 Residential Area', 0))
	mission1.append(goalClass.new('# of Commercial Areas', true, 1, 'Build 1 Commercial Area', 'Build 1 Commercial Area', 0))
	missions.append(mission1)
	
	var mission2 = []
	mission2.append(goalClass.new('# of Residential Areas', true, 5, 'Build 5 Residential Areas', 'Build 5 Residential Areas', 0))
	mission2.append(goalClass.new('# of Commercial Areas', true, 5, 'Build 5 Commercial Area', 'Build 5 Commercial Area', 0))
	mission2.append(goalClass.new('Money', true, 999999999999, 'We\'re rich!', 'Make $999,999,999,999', 1))
	missions.append(mission2)

func onNotify(event, stats):
	"""
	if missionIndex == 0:
		checkMissionZero(event, stats)
	elif missionIndex == 1:
		checkMissionOne(event, stats)
	"""
	for i in range(missions[0].size()):
		if missions[0][i].isComplete():
			unlock(missions[0][i], i)
	deleteGoals()
	#Check if we're done
	checkIfDone()

"""
func checkMissionZero(event, stats):
	if stats['# of Residential Areas'] >= 1:
		unlock('Build 1 Residential Area')
	if stats['# of Commercial Areas'] >= 1:
		unlock('Build 1 Commercial Area')

func checkMissionOne(event, stats):
	if stats['# of Residential Areas'] >= 5:
		unlock('Build 5 Residential Areas')
	if stats['# of Commercial Areas'] >= 5:
		unlock('Build 5 Commercial Areas')
"""

func unlock(miss, missNum):
	print("Mission Complete: " + miss.achievementName)
	toDelete.append(missNum)
	
	get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission" + str(missNum + 1)).add_color_override("font_color",  Color(0, 0.57, 0.05))

func getMissions():
	var listOfMissions = []
	for mission in missions[0]:
		listOfMissions.append(mission.achievementName)
	return listOfMissions

func deleteGoals():
	for num in toDelete:
		missions[0].remove(num)
	toDelete.clear()

func checkIfDone():
	# Check if all missions in this group our complete
	if missions[0].empty():
		print("All Missions Complete in Group #" + str(missionIndex))
		missionIndex += 1
		missions.remove(0) # Keep new set of missions at beginning
		displayNewMissions()
		#FIXME: When events are updates, replace "" with something better
		onNotify("", Announcer.stats) #Check onNotify to see if new goals are complete

func displayNewMissions():
	var missions = getMissions()
	get_node("/root/CityMap/HUD/MissionsBG").margin_bottom = 28 + (14 * missions.size()) + (20 * (missions.size() + 1))
	# I'm assuming there will always be at least one mission
	get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission1").text = missions[0]
	get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission1").add_color_override("font_color",  Color(1, 1, 1))
	if missions.size() > 1:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").text = missions[1]
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").add_color_override("font_color",  Color(1, 1, 1))
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").visible = true
	else:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").visible = false
	if missions.size() > 2:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").text = missions[2]
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").add_color_override("font_color",  Color(1, 1, 1))
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").visible = true
	else:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").visible = false
