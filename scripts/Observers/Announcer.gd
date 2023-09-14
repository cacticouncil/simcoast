class_name Announcer extends Node

var observers = Array()
var numOfObservers = 0

func addObserver(observer):
	observers.append(observer)
	numOfObservers = numOfObservers + 1

func removeObserver(observer):
	observers.erase(observer)
	numOfObservers = numOfObservers - 1

func notify(event):
	for i in numOfObservers:
		observers[i].onNotify(event)
