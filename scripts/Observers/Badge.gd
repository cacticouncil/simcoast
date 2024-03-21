extends Node

var badgeName #Name of badge
var badgeDescription #Description of badge
var badgeTier #0 is bronze, 1 is silver, 2 is gold
var icon # the string path to the related picture

func _init(_badgeName, _badgeDesc, _badgeTier, _icon):
	badgeName = _badgeName
	badgeDescription = _badgeDesc
	badgeTier = _badgeTier
	icon = _icon
