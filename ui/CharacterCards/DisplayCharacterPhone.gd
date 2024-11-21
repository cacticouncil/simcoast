extends VBoxContainer

export var seperation = 10

#This value is derived by the pixel length (x) of the icons (200 currently), plus the space between icons.
#var iconSize = 200 + seperation

"""
Note: see UnlockedBadges.gd for description on how seperation and sizes work
Character cards are displayed in the same way Badges are
"""

func _ready():
	var cards = NPCOrganizer.getUnlockedNPCs()
	#Calculates num of cards per row based on the length of the scene instatiated
	var cardsPerRow = 1
	var container
	
	#self.rect_position.x = 10
		
	for i in range(cards.size()):
		# We add cardsPerRow cards in one row and then create a new one
#		if i % cardsPerRow == 0:
		container = HBoxContainer.new()
		container.set("custom_constants/separation", 10)
		add_child(container)
			# This random control node was the easiest way to get the first spacing
		container.add_child(Control.new())
		var card = preload("res://ui/CharacterCards/CharacterPhone.tscn")
		var CardInstance = card.instance()
		
		var currCard = cards[i]
		#Instatiate a single instance of the card view and update the values
		CardInstance.updateValues(currCard)
		
		container.add_child(CardInstance)

#needed to keep the node in place (issue with Godot engine).
func _process(delta):
	#self.rect_position.x = 10
	pass
