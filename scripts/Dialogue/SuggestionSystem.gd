class_name SuggestionSystem extends Node


# Declare member variables here. Examples:
var houses = 0
var houseLimit = 2
var houseRatio = houses/houseLimit
var stores = 0
const storeLimit = 0.5
var storeRatio = (stores/houses)/storeLimit
var power = 0 
const powerLimit = 0.25
var powerRatio = (power/houses)/powerLimit

var priorityQueue
var size
# Called when the node enters the scene tree for the first time.
func init():
	priorityQueue.append('h')
	priorityQueue.append('s')
	priorityQueue.append('p')
	
# will utilize event class
func update():
	# if event is adding residential tile
	houses += 1
	update_house()
	# if event is adding commercial tile
	stores += 1
	update_store()
	# if event is adding power plant tile
	power += 1
	update_power()
	# always update queue
	update_queue()

func suggest():
	if priorityQueue.at(0) == 'h':
		return "You should build more houses!"
	elif priorityQueue.at(0) == 's':
		return "Maybe add a commercial zone!"
	else:
		return "Your city needs more power! Think about adding another power plant."

func update_queue():
	priorityQueue = []
	if(houseRatio <= storeRatio  && houseRatio <= powerRatio):
		if(storeRatio <= powerRatio):
			priorityQueue = ['h','s','p']
		else:
			priorityQueue = ['h','p','s']
	if(storeRatio <= houseRatio  && storeRatio <= powerRatio):
		if(houseRatio <= powerRatio):
			priorityQueue = ['s','h','p']
		else:
			priorityQueue = ['s','p','h']
	if(powerRatio <= houseRatio  && powerRatio <= storeRatio):
		if(houseRatio <= storeRatio):
			priorityQueue = ['p','h','s']
		else:
			priorityQueue = ['p','s','h']


func update_house():
	if houses >= houseLimit:
		houseLimit *=2
	houseRatio = houses/houseLimit
	update_store()
	update_power()
	
func update_store():
	storeRatio = (stores/houses)/storeLimit
	
func update_power():
	powerRatio = (power/houses)/powerLimit
	
	
