extends "res://scripts/Observers/Observer.gd"
#Handles Achievements

var toComplete = []
var completed = []

var toDelete = []

func get_completed_achievements():
	var names = []
	for goal in completed:
		names.append(goal.achievementName)
	
	return names
	
func load_achievements(data):
	# Clear existing achievments
	if not toComplete.empty():
		toComplete.clear()
		createAchievements()
	
	if not completed.empty():
		completed.clear()
		toDelete.clear()
	
	# Load new achievements by adding to completed
	# and removing from toComplete
	for i in range(toComplete.size()):
		if data.has(toComplete[i].achievementName):
			completed.append(toComplete[i])
			toDelete.append(i)

	deleteGoals()

	
func createAchievements():
	#Create achievements for the purpose of testing
	var goalClass = load("res://scripts/Observers/Goal.gd")
	toComplete.push_back(goalClass.new('# of Residential Areas', true, 10, 'Build 10 Residential Areas', 'Build 10 Residential Areas', "res://assets/achievement_icons/Construction Achievement.png"))
	toComplete.push_back(goalClass.new('# of Commercial Areas', true, 10, 'Build 10 Commercial Areas', 'Build 10 Commercial Areas', "res://assets/achievement_icons/Construction Achievement.png"))
	toComplete.push_back(goalClass.new('Money', true, 50000, 'Money Made', 'Have $50,000', "res://assets/achievement_icons/MoneyAchievement.png"))
	toComplete.append(goalClass.new('# of Parks', true, 5, 'Build 5 Parks', 'Build 5 Parks', "res://assets/achievement_icons/Construction Achievement.png"))
	toComplete.append(goalClass.new('Profit', true, 5000, 'Make $5,000 in one month', 'Make $5,000 in one month', "res://assets/achievement_icons/MoneyAchievement.png"))
	toComplete.append(goalClass.new('Total Population', true, 100, 'House 100 Citizents', 'Have a total population over 100', "res://assets/achievement_icons/Construction Achievement.png"))
	
	#Just for testing scrolling of achievement menu:
	toComplete.append(goalClass.new('Money', true, 100000, 'Have $100,000', 'Have $100,000', "res://assets/achievement_icons/MoneyAchievement.png"))
	toComplete.append(goalClass.new('Money', true, 200000, 'Have $200,000', 'Have $200,000', "res://assets/achievement_icons/MoneyAchievement.png"))

func onNotify(event):
	#Fun fact to anyone looking through this code: you can't delete from an array you're looping through in gdscript: https://ask.godotengine.org/77668/what-happens-when-i-remove-an-array-element-isnide-a-for-loop#:~:text=1%20Answer&text=Don't%20loop%20through%20the,loop%20through%20that%20array%20instead.
	for i in range(toComplete.size()):
		if toComplete[i].isComplete() and not inCompleted(toComplete[i].achievementName):
			unlock(toComplete[i], i)
	#Goals we want deleted are added to a list in unlock() and deleted here
	deleteGoals()

func inCompleted(name):
	for goal in completed:
		if name == goal.achievementName:
			return true
	
	return false

func unlock(goal, goalNum):
	toDelete.append(goalNum)
	completed.append(goal)
	#Displays achievements
	var pop = preload("res://ui/Popups/Overlay.tscn")
	#var popUpInstance = pop.instance()
	#get_parent().add_child(popUpInstance)
	get_node("/root/Overlay").achievement_pop(goal.achievementName, goal.icon)

func deleteGoals():
	# Delete in reverse order to not modify while iterating
	toDelete.invert()
	for num in toDelete:
		toComplete.remove(num)
	toDelete.clear()

func getLockedAchievements():
	return toComplete

func getUnlockedAchievements():
	return completed
