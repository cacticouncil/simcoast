class_name SfxObserver extends "res://scripts/Observers/Observer.gd"
#Handles SFX

#export var sfxPlayer : AudioStreamPlayer

func onNotify(event):
	# Plays some banger royalty free construction sfx
	if event.eventName == "Added Tile":
		if event.eventDescription == "Play SFX":
			playSFX("res://assets/sfx/Construction.mp3")

func playSFX(sfxPath):
	#Creates an AudioStreamPlayer to play a sound
	var sfxPlayer = AudioStreamPlayer.new()
	sfxPlayer.bus = "SFX"
	sfxPlayer.volume_db = -20.0
	sfxPlayer.stream = load(sfxPath)
	self.add_child(sfxPlayer)
	sfxPlayer.play()
	
