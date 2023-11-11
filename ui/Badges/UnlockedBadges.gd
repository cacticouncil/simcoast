extends VBoxContainer

export var seperation = 10

#This value is derived by the pixel length of the icons, then 
var iconSize = 64 + seperation

"""
Little explanation of the seperation and icon size stuff:
If we have n badges, size we start with a seperation, we have n + 1 seperations.
We can view n of those to be attached to a respective icon. Since we have 1 more
seperation, we subtract it from the size.x value because that gives use the
space the badges have left to share. So thats why all these numbers work as they
do.
"""

func _ready():
	var badges = BadgeObserver.getBadges()
	var badgesPerRow = int((get_size().x - seperation) / iconSize)
	var container
	
	for i in range(badges.size()):
		# We have 3 badges side by side, then print on the next row
		if i % badgesPerRow == 0:
			container = HBoxContainer.new()
			container.set("custom_constants/separation", 10)
			add_child(container)
			# This random control node was the easiest way to get the first spacing
			container.add_child(Control.new())
		var badge = preload("res://ui/Badges/Badge.tscn")
		var BadgeInstance = badge.instance()
		
		var currBadge = badges[i]
		BadgeInstance.updateValues(currBadge.icon, currBadge.badgeTier)
		
		container.add_child(BadgeInstance)
