extends Node

var stats = {
	'# of Residential Areas': 0, 
	'# of Commercial Areas': 0,
	'# of Power Plants': 0,
	'# of Roads': 0,
	'# of Parks': 0,
	'# of Powered Roads': 0,
	'# of Powered Comm': 0,
	'# of Powered Res': 0,
	'Money': 0,
	'Total Population': 0
}

func getStat(name):
	return stats[name]

func updateStats(event):
	if event.eventName == "Tiles Powered":
		"""
		Quick explination on why we have two seperate sections for powered roads.
		So, this area handles when we place roads/power plants. There's a function in City
		that loops over the map whenever we place one of these in case other tiles are now
		powered because of that road. However, the other section (Added Powered Tiles) is
		called whenever we place a res/commercial zone. Because, the tiles they are placed
		on will already be powered/not powered when they're placed, so connect power is not
		called. That's why they're both here. Sorry if that explanation is long.
		"""
		if event.eventDescription == "Number of powered roads":
			stats['# of Powered Roads'] = event.eventValue
		elif event.eventDescription == "Number of powered commercial areas":
			stats['# of Powered Comm'] = event.eventValue
		elif event.eventDescription == "Number of powered residential areas":
			stats['# of Powered Res'] = event.eventValue
	elif event.eventName == "Added Tile":
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
	elif event.eventName == "Added Powered Tile":
		if event.eventDescription == "Added Commercial Area":
			stats['# of Powered Comm'] += event.eventValue
		elif event.eventDescription == "Added Resedential Area":
			stats['# of Powered Res'] += event.eventValue
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
