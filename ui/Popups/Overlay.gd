extends CanvasLayer

#Source - https://www.youtube.com/watch?v=rJcy221LrYs
var overlayPopup = preload("res://ui/Popups/OverlayPopup.tscn")
var errorPopup = preload("res://ui/Popups/ErrorPopup.tscn")
var warningPopup = preload("res://ui/Popups/WarningPopup.tscn")
# A queue of the name of achievements, the first one is the next one displayed
var queue = []
# We use a queue in case multiple achievements are unlocked at once

#Calls to popup animation in Overlay scene
func achievement_pop(achName, achPic):
	var inst = overlayPopup.instance()
	inst.set_values(achName, achPic)
	inst.name = achName
	inst.visible = false
	queue.append(achName)
	$OverlayControl.add_child(inst)
	# Made a sick fade animation
	$AnimationPlayer.queue("Fade")

func error_pop(errorDesc):
	#Only add popup if it doesn't already exist
	if get_node_or_null("/root/Overlay/OverlayControl/Insufficient Funds") == null:
		var inst = errorPopup.instance()
		inst.set_values(errorDesc, "res://assets/achievement_icons/ErrorIcon.png")
		inst.name = errorDesc
		inst.visible = false
		queue.append(errorDesc)
		$OverlayControl.add_child(inst)
		# Made a sick fade animation
		$AnimationPlayer.queue("Fade")

func warning_pop(wName, warningPic, wColor):
	if get_node_or_null("/root/Overlay/OverlayControl/Warning") == null:
		var inst = warningPopup.instance()
		inst.set_warning(wName, warningPic, wColor)
		inst.name = "Warning"
		inst.visible = false
		queue.append("Warning")
		$OverlayControl.add_child(inst)
		# Made a sick fade animation
		$AnimationPlayer.queue("Fade")

func animationStart():
	get_node("/root/Overlay/OverlayControl/" + queue[0]).visible = true

func animationEnd():
	$OverlayControl.remove_child(get_node("/root/Overlay/OverlayControl/" + queue[0]))
	queue.remove(0)
