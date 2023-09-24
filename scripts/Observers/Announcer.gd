extends Node

var observers = Array()
var numOfObservers = 0

# Stats that observers care about
var stats = {
	'# of Residential Areas': 0, 
	'# of Commercial Areas': 0,
	'Money': 0
}

func addObserver(observer):
	observers.append(observer)
	numOfObservers = numOfObservers + 1

func removeObserver(observer):
	observers.erase(observer)
	numOfObservers = numOfObservers - 1

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

func notify(event):
	updateStats(event)
	for i in numOfObservers:
		observers[i].onNotify(event, stats)
