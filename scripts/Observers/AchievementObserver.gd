extends "res://scripts/Observers/Observer.gd"
#Handles Achievements

var toComplete = []
var completed = []

var toDelete = []

func createAchievements():
	#Create achievements for the purpose of testing
	var goalClass = load("res://scripts/Observers/Goal.gd")
	toComplete.push_back(goalClass.new('# of Residential Areas', true, 10, 'Build 10 Residential Areas', 'Build 10 Residential Areas', 0))
	toComplete.push_back(goalClass.new('# of Commercial Areas', true, 10, 'Build 10 Commercial Areas', 'Build 10 Commercial Areas', 0))
	toComplete.push_back(goalClass.new('Money', true, 110000, 'Money Made', 'Make $110,000', 1))
	toComplete.append(goalClass.new('Money', true, 105000, 'Have $105,000', 'Make $105,000', 1))
	toComplete.append(goalClass.new('# of Parks', true, 5, 'Build 5 Parks', 'Build 5 Parks', 0))
	toComplete.append(goalClass.new('Profit', true, 5000, 'Make $5,000 in one month', 'Make $5,000 in one month', 1))
	toComplete.append(goalClass.new('Total Population', true, 100, 'House 100 Citizents', 'Have a total population over 100', 0))
	
	#Get rid of these, just for testing scrolling of achievement menu:
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))
	toComplete.append(goalClass.new('Money', true, 99999999999999, 'Have $99999999999999', 'Make $99999999999999', 1))

func onNotify(event):
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
		Overlay.b_achievement_pop(goal.achievementName)
	#Displays economic achievement
	elif (goal.achievementType == 1):
		Overlay.e_achievement_pop()

func deleteGoals():
	for num in toDelete:
		toComplete.remove(num)
	toDelete.clear()

func getLockedAchievements():
	return toComplete

func getUnlockedAchievements():
	return completed
