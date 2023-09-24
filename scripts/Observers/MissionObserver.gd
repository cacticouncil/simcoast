extends "res://scripts/Observers/Observer.gd"
#Handles Missions, unlike Achievements, these need a sense of progression

# Missions are a list of dictionaries that are individual sets of missions
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
		unlock('Build 1 Residential Area', 0)
	if stats['# of Commercial Areas'] >= 1:
		unlock('Build 1 Commercial Area', 0)

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
		
		get_node("/root/CityMap/HUD/Missions/VBoxContainer/Mission" + str(missions[i].keys().find(missName) + 1)).add_color_override("font_color",  Color(0, 0.57, 0.05))
		
		# Check if all missions in this group our complete
		var groupComplete = true
		for mission in missions[i].values():
			if !mission:
				groupComplete = false
		if groupComplete:
			print("All Missions Complete in Group #" + str(i))
			missionStats['Mission Index'] += 1
			displayNewMissions()

func getMissions():
	var listOfMissions = []
	for mission in missions[missionStats['Mission Index']]:
		listOfMissions.append(mission)
	return listOfMissions

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
