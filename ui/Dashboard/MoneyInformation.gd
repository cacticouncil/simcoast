extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

# Information about money is displayed as popup when mouse hovers over information icon
func _on_MoneyInfoButton_mouse_entered():
	visible = true

func _on_MoneyInfoButton_mouse_exited():
	visible = false

