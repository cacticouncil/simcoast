extends "res://scripts/Observers/Observer.gd"
#Handles Achievements

# TO DO: More properties for achievements (e.g. types, names)
# The reason these are dictionaries instead of vars is persistence issues
"""
var achievements = {
	'Money Made': false, 
	'Build 10 Residential Areas': false, 
	'Build 10 Commercial Areas': false
}
"""
var toComplete = []
var completed = []

var toDelete = []

func createAchievements():
	var goalClass = load("res://scripts/Observers/Goal.gd")
	toComplete.push_back(goalClass.new('# of Residential Areas', true, 10, 'Build 10 Residential Areas', 'Build 10 Residential Areas', 0))
	toComplete.push_back(goalClass.new('# of Commercial Areas', true, 10, 'Build 10 Commercial Areas', 'Build 10 Commercial Areas', 0))
	toComplete.push_back(goalClass.new('Money', true, 110000, 'Money Made', 'Make $110,000', 1))

func onNotify(event, stats):
	#Fun fact to anyone looking through this code: you can't delete from an array you're looping through in gdscript: https://ask.godotengine.org/77668/what-happens-when-i-remove-an-array-element-isnide-a-for-loop#:~:text=1%20Answer&text=Don't%20loop%20through%20the,loop%20through%20that%20array%20instead.
	for i in range(toComplete.size()):
		if toComplete[i].isComplete():
			unlock(toComplete[i], i)
	#Goals we want deleted are added to a list in unlock() and deleted here
	deleteGoals()

func unlock(goal, goalNum):
	print("Achievement Unlocked: " + goal.achievementName)
	toDelete.append(goalNum)
	completed.append(goal)
	#Displays building achievement
	if (goal.achievementType == 0):
		Overlay.b_achievement_pop()
	#Displays economic achievement
	elif (goal.achievementType == 1):
		Overlay.e_achievement_pop()

func deleteGoals():
	for num in toDelete:
		toComplete.remove(num)
	toDelete.clear()
