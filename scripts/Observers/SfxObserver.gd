class_name SfxObserver extends "res://scripts/Observers/Observer.gd"
#Handles SFX

#export var sfxPlayer : AudioStreamPlayer

func onNotify(event, stats):
	if event.eventName == "Added Tile":
		if event.eventDescription == "Added Resedential Area" || event.eventDescription == "Added Commercial Area":
			playSFX("res://assets/sfx/Construction.mp3")

func playSFX(sfxPath):
	var sfxPlayer = AudioStreamPlayer.new()
	sfxPlayer.bus = "SFX"
	sfxPlayer.volume_db = -20.0
	sfxPlayer.stream = load(sfxPath)
	self.add_child(sfxPlayer)
	sfxPlayer.play()
	
