extends "res://scripts/Observers/Observer.gd"
#Handles Missions, unlike Achievements, these need a sense of progression

# Missions are a list of dictionaries that are individual sets of missions
var missions = []

var toDelete = []

# Mission index keeps track of which set of mission set we're on
var missionIndex = 0

func createMissions():
	# Creates goal objects for the purpose of testing
	var goalClass = load("res://scripts/Observers/Goal.gd")
	
	var mission1 = []
	mission1.append(goalClass.new('# of Residential Areas', true, 1, 'Build 1 Residential Area', 'Build 1 Residential Area', 0))
	mission1.append(goalClass.new('# of Commercial Areas', true, 1, 'Build 1 Commercial Area', 'Build 1 Commercial Area', 0))
	missions.append(mission1)
	
	var mission2 = []
	mission2.append(goalClass.new('# of Residential Areas', true, 5, 'Build 5 Residential Areas', 'Build 5 Residential Areas', 0))
	mission2.append(goalClass.new('# of Commercial Areas', true, 5, 'Build 5 Commercial Areas', 'Build 5 Commercial Areas', 0))
	mission2.append(goalClass.new('Money', true, 999999999999, 'We\'re rich!', 'Make $999,999,999,999', 1))
	missions.append(mission2)

func onNotify(event, stats):
	# Whenever we're notified, check if we've completed any of our missions
	for i in range(missions[0].size()):
		if missions[0][i].isComplete():
			unlock(missions[0][i], i)
	# Can't delete during unlock so do it here (Check mission observer)
	deleteGoals()
	#Check if we're done
	checkIfDone()

func unlock(miss, missNum):
	# Mark as finished
	print("Mission Complete: " + miss.achievementName)
	toDelete.append(missNum)
	
	#Find the right node, change the color
	if get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission1").text == miss.achievementName:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission1").add_color_override("font_color",  Color(0, 0.57, 0.05))
	elif get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").text == miss.achievementName:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").add_color_override("font_color",  Color(0, 0.57, 0.05))
	elif get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").text == miss.achievementName:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").add_color_override("font_color",  Color(0, 0.57, 0.05))

func getMissions():
	# Returns a list of the mission name in string format
	var listOfMissions = []
	for mission in missions[0]:
		listOfMissions.append(mission.achievementName)
	return listOfMissions

func deleteGoals():
	# Remove all goals from missions that are stored by index in toDelete
	for num in toDelete:
		missions[0].remove(num)
	toDelete.clear()

func checkIfDone():
	# Check if all missions in this group our complete
	if missions[0].empty():
		print("All Missions Complete in Group #" + str(missionIndex))
		missionIndex += 1
		missions.remove(0) # Keep new set of missions at beginning
		#FIXME: This is to prevent crashing when missions are done, will eventually want to figure out what to do in that case
		if missions.empty():
			createMissions()
		displayNewMissions()
		#FIXME: When events are updates, replace "" with something better
		onNotify("", Announcer.stats) #Check onNotify to see if new goals are complete

func hoverMission(index):
	# Currently useless while I figure out hover text
	get_node("/root/HUD/BottomBar/HoverText").text = missions[0][index].achievementDescription

func unhoverMission():
	# Currently useless while I figure out hover text
	get_node("/root/HUD/BottomBar/HoverText").text = ""

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
