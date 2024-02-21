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
	
	var mission0 = []
	mission0.append(goalClass.new('# of Power Plants', true, 1, 'Build a Power Plant', 'Build a Power Plant', "res://assets/achievement_icons/Construction Achievement.png"))
	missions.append(mission0)
	
	var mission1 = []
	mission1.append(goalClass.new('# of Roads', true, 5, 'Build 5 Roads', 'Build 5 roads', "res://assets/achievement_icons/Construction Achievement.png"))
	mission1.append(goalClass.new('# of Powered Roads', true, 5, 'Power 5 roads', 'Connect roads to a power plant to power them', "res://assets/achievement_icons/Construction Achievement.png"))
	missions.append(mission1)
	
	var mission2 = []
	mission2.append(goalClass.new('# of Residential Areas', true, 3, 'Build 3 Residential Areas', 'Build 3 Residential Areas', "res://assets/achievement_icons/Construction Achievement.png"))
	mission2.append(goalClass.new('# of Powered Res', true, 3, 'Power 3 Residential Areas', 'Connect the residential areas to roads to power them', "res://assets/achievement_icons/Construction Achievement.png"))
	missions.append(mission2)
	
	var mission3 = []
	mission3.append(goalClass.new('# of Commercial Areas', true, 3, 'Build 3 Commercial Areas', 'Build 3 Commercial Areas', "res://assets/achievement_icons/Construction Achievement.png"))
	mission3.append(goalClass.new('# of Powered Comm', true, 3, 'Power 3 Commercial Areas', 'Connect the commercial areas to roads to power them', "res://assets/achievement_icons/Construction Achievement.png"))
	missions.append(mission3)
	
	var missionUnbeatable = [] # FIXME: Handle what happens when all missions are complete
	missionUnbeatable.append(goalClass.new('Money', true, 999999999999, 'We\'re rich!', 'Make $999,999,999,999', "res://assets/achievement_icons/MoneyAchievement.png"))
	missions.append(missionUnbeatable)

func onNotify(event):
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

func getMissionsDescriptions():
	# Returns a list of the mission descriptions in string format
	var listOfMissions = []
	for mission in missions[0]:
		listOfMissions.append(mission.achievementDescription)
	return listOfMissions

func deleteGoals():
	# Remove all goals from missions that are stored by index in toDelete
	toDelete.invert() # Needs to be invert, otherwise breaks having multiple missions completed when we move onto next set
	for num in toDelete:
		missions[0].remove(num)
	toDelete.clear()

func checkIfDone():
	# Check if all missions in this group our complete
	if missions[0].empty():
		missionIndex += 1
		missions.remove(0) # Keep new set of missions at beginning
		#FIXME: This is to prevent crashing when missions are done, will eventually want to figure out what to do in that case
		if missions.empty():
			createMissions()
		displayNewMissions()
		#FIXME: When events are updates, replace "" with something better
		onNotify("") #Check onNotify to see if new goals are complete
		Announcer.notify(Event.new("Completed Mission", "Completed Mission", missionIndex - 1)) # Mission index - 1 because it's the last group

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
	get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission1").connect("mouse_entered", self, "show_mission_tip", [0])
	get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission1").connect("mouse_exited", self, "clear_mission_tip")
	if missions.size() > 1:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").text = missions[1]
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").add_color_override("font_color",  Color(1, 1, 1))
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").connect("mouse_entered", self, "show_mission_tip", [1])
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").connect("mouse_exited", self, "clear_mission_tip")
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").visible = true
	else:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission2").visible = false
	if missions.size() > 2:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").text = missions[2]
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").add_color_override("font_color",  Color(1, 1, 1))
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").connect("mouse_entered", self, "show_mission_tip", [2])
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").connect("mouse_exited", self, "clear_mission_tip")
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").visible = true
	else:
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission3").visible = false

func show_mission_tip(num):
	get_node("/root/CityMap/HUD/BottomBar/HoverText").text = getMissionsDescriptions()[num]

func clear_mission_tip():
	get_node("/root/CityMap/HUD/BottomBar/HoverText").text = ""
