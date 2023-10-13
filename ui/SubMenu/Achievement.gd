extends Node

# Called when the node enters the scene tree for the first time.
func updateValues(aName, aDesc, aValue, aConst, completed):
	$AchievementName.text = aName
	$AchievementDescription.text = aDesc
	$ProgressBarFilled.set_size(Vector2(248 * (float(aValue)/float(aConst)), 15))
	$ProgressNumber.text = str(aValue) + "/" + str(aConst)
	if completed:
		$Uncompleted.visible = false
