extends "res://scripts/Observers/Observer.gd"
#Handles Badges

var badgeScript = preload("res://scripts/Observers/Badge.gd")
var badges = []

var popupImagePath = "res://assets/achievement_icons/BadgeAchievement.png"

func onNotify(event):
	if event.eventName == "Unlocked Badge":
		badges.append(badgeScript.new(event.eventDescription, event.eventDescription + " Description", event.eventValue, "res://assets/badge_icons/test_badge.png"))
			#get_node("/root/Overlay").achievement_pop(event.eventDescription, popupImagePath)

func getBadges():
	return badges

