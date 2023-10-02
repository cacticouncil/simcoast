extends Node

# Properties of a goal
var varToCheck #Name of statistic in announcer to check
var greaterThan #true check >, false checks <
var constGoal #Const to check against
var achievementName # name
var achievementDescription # description
var achievementType #achType for ach popup
# var reward?
# var icon? if we want a pic associated with an icon
# For icons?:
# https://sketch.io/

func _init(_varToCheck, _greaterThan, _constGoal, _achievementName, _achievementDescription, _achievementType):
	varToCheck = _varToCheck
	greaterThan = _greaterThan
	constGoal = _constGoal
	achievementName = _achievementName
	achievementDescription = _achievementDescription
	achievementType = _achievementType

func isComplete():
	if greaterThan:
		return Announcer.stats[varToCheck] >= constGoal
	else:
		return Announcer.stats[varToCheck] <= constGoal
