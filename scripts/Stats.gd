extends Node

var stats = {
	'# of Residential Areas': 0, 
	'# of Commercial Areas': 0,
	'Money': 0
}

func getStat(name):
	return stats[name]

func updateStats(event):
	if event.eventName == "Added Tile":
		if event.eventDescription == "Added Resedential Area":
			stats['# of Residential Areas'] += event.eventValue
		elif event.eventDescription == "Added Commercial Area":
			stats['# of Commercial Areas'] += event.eventValue
	elif event.eventName == "Removed Tile":
		if event.eventDescription == "Removed Residential Area":
			stats['# of Residential Areas'] -= event.eventValue
		elif event.eventDescription == "Removed Commercial Area":
			stats['# of Commercial Areas'] -= event.eventValue
	elif event.eventName == "Money":
		stats['Money'] = event.eventValue
