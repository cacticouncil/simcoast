extends Node

var coastal_defense = 0
var hurricane_prep


func updateHurricanePrep():
	for key in Global.activeTiles:
		var tile = Global.tileMap[key[0]][key[1]]
		
