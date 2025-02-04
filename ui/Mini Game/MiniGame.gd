extends Node2D

var food_waste_sprites = ["res://assets/Beach Cleanup/apple core.png", 
						"res://assets/Beach Cleanup/apples.png", 
						"res://assets/Beach Cleanup/banana-skin.png",
						"res://assets/Beach Cleanup/egg shell.png",
						"res://assets/Beach Cleanup/sandwhich.png",
						"res://assets/Beach Cleanup/watermelon.png"]
var recycling_sprites = ["res://assets/Beach Cleanup/bottle.png",
						"res://assets/Beach Cleanup/boxes.png",
						"res://assets/Beach Cleanup/brown container.png",
						"res://assets/Beach Cleanup/can.png",
						"res://assets/Beach Cleanup/coffee cup.png",
						"res://assets/Beach Cleanup/container.png",
						"res://assets/Beach Cleanup/cup.png",
						"res://assets/Beach Cleanup/newspaper.png",
						"res://assets/Beach Cleanup/paper bag.png",
						"res://assets/Beach Cleanup/plastic bag.png",
						"res://assets/Beach Cleanup/plastic-bags.png"]
var trash_sprites = ["res://assets/Beach Cleanup/teddy bear.png",
					"res://assets/Beach Cleanup/football.png"]

var accuracy = 100
var remaining_trash = 5

var num_items = 5
var trash_positions = []
onready var trash_items_scene = preload("res://ui/Mini Game/TrashItems.tscn")

func _process(delta):
	if remaining_trash == 0:
		UpdateTrashLevel.minigame_reduction(accuracy)
		get_parent().remove_child(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	trash_positions = $Beach/TrashPositions.get_children()
	print(trash_positions.size())
	
	var trash_items = trash_items_scene.instance()
	var trash_nodes = trash_items.get_children()
	var chosen_items = get_random_nodes(trash_nodes, num_items)
	var chosen_positions = get_random_nodes(trash_positions, num_items)
	
	for i in range(num_items):
		var trash_item_instance = chosen_items[i].duplicate()
		trash_item_instance.position = chosen_positions[i].global_position
		add_child(trash_item_instance)
		
		# Connect the item_dropped signal and pass the trash item instance
		trash_item_instance.connect("item_dropped", self, "_on_item_dropped", [trash_item_instance])

# Updated _on_item_dropped function
func _on_item_dropped(texture_path, pos, trash_item_instance):
	# Check if the item was dropped in any of the bins
	if is_overlapping($Beach/FoodWaste/FWCollision, pos):
		print("Item dropped in Food Waste bin.")
		if not texture_path in food_waste_sprites:
			accuracy -= 100 / num_items
		remaining_trash -= 1
		trash_item_instance.queue_free()  # Remove the trash item from the scene
	elif is_overlapping($Beach/RecyclingBin/RBCollision, pos):
		print("Item dropped in Recycling bin.")
		if not texture_path in recycling_sprites:
			accuracy -= 100 / num_items
		remaining_trash -= 1
		trash_item_instance.queue_free()  # Remove the trash item from the scene
	elif is_overlapping($Beach/TrashBin/TBCollision, pos):
		print("Item dropped in Trash bin.")
		if not texture_path in trash_sprites:
			accuracy -= 100 / num_items
		remaining_trash -= 1
		trash_item_instance.queue_free()  # Remove the trash item from the scene

func get_random_nodes(nodes, amount):
	var selected = []
	var indices = range(nodes.size())
	for i in range(amount):
		var random = randi() % indices.size()
		selected.append(nodes[indices[random]])
		indices.erase(indices[random])
	return selected

func is_overlapping(node: CollisionShape2D, pos: Vector2) -> bool:
	# Get the global position and scale of the CollisionShape2D's parent
	var global_position = node.get_global_position()
	
	var collision_shape = node.shape
	# Calculate the full size using extents and global scale
	var rect_size = collision_shape.extents * 2 * node.get_global_scale()
	# Create a rectangle centered on the global position
	var rect = Rect2(global_position - rect_size / 2, rect_size)
	# Check if the position is within the rectangle
	return rect.has_point(pos)

func _on_FoodWaste_area_entered(area):
	$Beach/FoodWaste/FWTexture.material.set_shader_param("enable", true)

func _on_FoodWaste_area_exited(area):
	$Beach/FoodWaste/FWTexture.material.set_shader_param("enable", false)

func _on_RecyclingBin_area_entered(area):
	$Beach/RecyclingBin/RBTexture.material.set_shader_param("enable", true)

func _on_RecyclingBin_area_exited(area):
	$Beach/RecyclingBin/RBTexture.material.set_shader_param("enable", false)

func _on_TrashBin_area_entered(area):
	$Beach/TrashBin/TBTexture.material.set_shader_param("enable", true)

func _on_TrashBin_area_exited(area):
	$Beach/TrashBin/TBTexture.material.set_shader_param("enable", false)
