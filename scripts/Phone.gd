extends CanvasLayer

#stores the current npc from clicked character card
var currNPC

# Called when the node enters the scene tree for the first time.
func _ready():
	#connects signal to phone character card scene
	SceneManager.connect("phone_npc_clicked", self, "_npc_callback")

# called when signal is received from character card scene
# which happens when a character card is clicked
func _npc_callback(npc_character):
	# changes name and info to that specific clicked character card
	currNPC = npc_character
	var picPath = "res://assets/office/"+currNPC.name+".png"
	$phone_info/photo.texture = load(picPath)
	$phone_info/name.text = currNPC.name
	$phone_info/job.text = currNPC.job
	$phone_info/jobdesc.text = currNPC.description
	$phone_info/fee.text = str("You can consult with ",currNPC.name, " for free.")
	$phone_info.visible = true
	$ScrollContainer.visible = false

# closes phone scene
func _on_quit_phone_pressed():
	get_parent().remove_child(self)

# closes extra info
func _on_phone_info_pressed():
	$phone_info.visible = false
	$ScrollContainer.visible = true
