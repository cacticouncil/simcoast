extends CanvasLayer

#Source - https://www.youtube.com/watch?v=rJcy221LrYs
var overlayPopup = preload("res://ui/Popups/OverlayPopup.tscn")

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

func animationStart():
	get_node("/root/Overlay/OverlayControl/" + queue[0]).visible = true

func animationEnd():
	$OverlayControl.remove_child(get_node("/root/Overlay/OverlayControl/" + queue[0]))
	queue.remove(0)
