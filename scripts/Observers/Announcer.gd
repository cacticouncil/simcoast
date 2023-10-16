extends Node

var observers = Array()
var numOfObservers = 0

func addObserver(observer):
	observers.append(observer)
	numOfObservers = numOfObservers + 1

func removeObserver(observer):
	observers.erase(observer)
	numOfObservers = numOfObservers - 1

func notify(event):
	Stats.updateStats(event)
	# Time to announce to all the observers
	for i in numOfObservers:
		observers[i].onNotify(event)
