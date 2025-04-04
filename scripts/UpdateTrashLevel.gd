extends Node

# Start with trash at level 0
var trash_level = 0
var trash_rate = 0.1

func update_trash():
	trash_level += trash_rate
	#print("Trash level:", trash_level)
	clamp(trash_level, 0, 100)
	Beach.update_counts()

func minigame_reduction(accuracy):
	trash_level -= 0.1 * accuracy
	max(trash_level, 0)
