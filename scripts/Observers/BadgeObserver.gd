extends "res://scripts/Observers/Observer.gd"
#Handles Badges

var badgeScript = preload("res://scripts/Observers/Badge.gd")
var badges = []

#TODO: Add achievements for badges
var popupImagePath = "res://assets/achievement_icons/BadgeAchievement.png"

func onNotify(event):
	if event.eventName == "Unlocked Badge":
		badges.append(badgeScript.new(event.eventDescription, event.eventDescription + " Description", event.eventValue, "res://assets/badge_icons/test_badge.png"))

func getBadges():
	return badges


