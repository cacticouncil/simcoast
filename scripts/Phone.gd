extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currNPC

# Called when the node enters the scene tree for the first time.
func _ready():
	#SceneManager.phone_npc_clicked.connect(handle_npc_clicked())
	SceneManager.connect("phone_npc_clicked", self, "_npc_callback")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _npc_callback(npc_character):
	currNPC = npc_character
	var picPath = "res://assets/office/"+currNPC.name+".png"
	$phone_info/photo.texture = load(picPath)
	$phone_info/name.text = currNPC.name
	$phone_info/job.text = currNPC.job
	if currNPC.name !="Jermaine":
		$phone_info/jobdesc.text = "No information available at the moment. Please check later!"
	else:
		$phone_info/jobdesc.text = "A deputy mayor assists the mayor in matters of running the city. He chairs council meetings, liaisons with the community, and acts on behalf of the mayor."
	$phone_info/fee.text = str("You can consult with ",currNPC.name, " for free.")
	$phone_info.visible = true
	$ScrollContainer.visible = false



func _on_quit_phone_pressed():
	get_parent().remove_child(self)


func _on_phone_info_pressed():
	$phone_info.visible = false
	$ScrollContainer.visible = true
