extends Node

var stats = {
	'# of Residential Areas': 0, 
	'# of Commercial Areas': 0,
	'# of Power Plants': 0,
	'# of Roads': 0,
	'# of Parks': 0,
	'Money': 0,
	'Total Population': 0
}

func getStat(name):
	return stats[name]

func updateStats(event):
	if event.eventName == "Added Tile":
		if event.eventDescription == "Added Resedential Area":
			stats['# of Residential Areas'] += event.eventValue
		elif event.eventDescription == "Added Commercial Area":
			stats['# of Commercial Areas'] += event.eventValue
		elif event.eventDescription == "Added Power Plant":
			stats['# of Power Plants'] += event.eventValue
		elif event.eventDescription == "Added Road":
			stats['# of Roads'] += event.eventValue
		elif event.eventDescription == "Added Park":
			stats['# of Parks'] += event.eventValue
	elif event.eventName == "Removed Tile":
		if event.eventDescription == "Removed Residential Area":
			stats['# of Residential Areas'] -= event.eventValue
		elif event.eventDescription == "Removed Commercial Area":
			stats['# of Commercial Areas'] -= event.eventValue
		elif event.eventDescription == "Removed Power Plant":
			stats['# of Power Plants'] -= event.eventValue
		elif event.eventDescription == "Removed Road":
			stats['# of Roads'] -= event.eventValue
		elif event.eventDescription == "Removed Park":
			stats['# of Parks'] -= event.eventValue
	elif event.eventName == "Money":
		stats['Money'] = event.eventValue
	elif event.eventName == "Profit":
		stats['Profit'] = event.eventValue
	elif event.eventName == "Total Population":
		stats['Total Population'] = event.eventValue
