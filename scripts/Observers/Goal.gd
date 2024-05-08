# Properties of a goal
var varToCheck #Name of statistic in announcer to check
var greaterThan #true check >, false checks <
var constGoal #Const to check against
var achievementName # name
var achievementDescription # description
var achievementType #achType for ach popup
var icon # the string path to the related picture
# var reward?
# For icons?:
# https://sketch.io/

func _init(_varToCheck, _greaterThan, _constGoal, _achievementName, _achievementDescription, _icon):
	varToCheck = _varToCheck
	greaterThan = _greaterThan
	constGoal = _constGoal
	achievementName = _achievementName
	achievementDescription = _achievementDescription
	icon = _icon

func isComplete():
	if greaterThan:
		return Stats.getStat(varToCheck) >= constGoal
	else:
		return Stats.getStat(varToCheck) <= constGoal
