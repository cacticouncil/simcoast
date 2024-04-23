extends CanvasLayer

var RainInfo = preload("res://ui/WarningSystem/RainInfo.tscn")
var RainInfoInstance = RainInfo.instance()
var AnemometerInfo = preload("res://ui/WarningSystem/AneInfo.tscn")
var AnemometerInfoInstance = AnemometerInfo.instance()
var TideInfo = preload("res://ui/WarningSystem/TideInfo.tscn")
var TideInfoInstance = TideInfo.instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(RainInfoInstance)

func _on_QuitButton_pressed():
	$QuitButton.material.set_shader_param("value", 1)
	get_node("/root/CityMap/HUD/TopBarBG/AchievementSelected").visible = false
	queue_free()

func _on_QuitButton_mouse_entered():
	$QuitButton.material.set_shader_param("value", 0.3)

func _on_QuitButton_mouse_exited():
	$QuitButton.material.set_shader_param("value", 1)

func _on_QuitButton_button_down():
	$QuitButton.material.set_shader_param("value", 0.1)

func _on_Rain_pressed():
	var currNode = get_node_or_null("AneInfo")
	if currNode != null:
		remove_child(currNode)
	currNode = get_node_or_null("TideInfo")
	if currNode != null:
		remove_child(currNode)
	add_child(RainInfoInstance)
	
	$Buttons/Rain/Button.disabled = true
	$Buttons/Anemometer/Button.disabled = false
	$Buttons/Tide/Button.disabled = false
	
	$Buttons/Rain/ColorRect.rect_min_size = Vector2(426, 83)
	$Buttons/Anemometer/ColorRect.rect_min_size = $Buttons/Rain/Button.rect_min_size
	$Buttons/Tide/ColorRect.rect_min_size = $Buttons/Tide/Button.rect_min_size

func _on_Anemometer_pressed():
	var currNode = get_node_or_null("RainInfo")
	if currNode != null:
		remove_child(currNode)
	currNode = get_node_or_null("TideInfo")
	if currNode != null:
		remove_child(currNode)
	add_child(AnemometerInfoInstance)
	
	$Buttons/Rain/Button.disabled = false
	$Buttons/Anemometer/Button.disabled = true
	$Buttons/Tide/Button.disabled = false
	
	$Buttons/Rain/ColorRect.rect_min_size = $Buttons/Rain/Button.rect_min_size
	$Buttons/Anemometer/ColorRect.rect_min_size = Vector2(426, 83)
	$Buttons/Tide/ColorRect.rect_min_size = $Buttons/Tide/Button.rect_min_size

func _on_Tide_pressed():
	var currNode = get_node_or_null("RainInfo")
	if currNode != null:
		remove_child(currNode)
	currNode = get_node_or_null("AneInfo")
	if currNode != null:
		remove_child(currNode)
	add_child(TideInfoInstance)
	
	$Buttons/Rain/Button.disabled = false
	$Buttons/Anemometer/Button.disabled = false
	$Buttons/Tide/Button.disabled = true
	
	$Buttons/Rain/ColorRect.rect_min_size = $Buttons/Rain/Button.rect_min_size
	$Buttons/Anemometer/ColorRect.rect_min_size = $Buttons/Tide/Button.rect_min_size
	$Buttons/Tide/ColorRect.rect_min_size = Vector2(426, 83)
