extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/TropicalStorm/CenterContainer2/HBoxContainer/TropicalStormSlider.value = UpdateWeather.tideTropStormWarning
	$VBoxContainer/TropicalStorm/CenterContainer3/TropicalStormValue.text = str(UpdateWeather.tideTropStormWarning) + " FT"
	
	$VBoxContainer/Category1/CenterContainer2/HBoxContainer/Category1Slider.value = UpdateWeather.tideCategory1Warning
	$VBoxContainer/Category1/CenterContainer3/Category1Value.text = str(UpdateWeather.tideCategory1Warning) + " FT"
	
	$VBoxContainer/Category2/CenterContainer2/HBoxContainer/Category2Slider.value = UpdateWeather.tideCategory2Warning
	$VBoxContainer/Category2/CenterContainer3/Category2Value.text = str(UpdateWeather.tideCategory2Warning) + " FT"
	
	$VBoxContainer/Category3/CenterContainer2/HBoxContainer/Category3Slider.value = UpdateWeather.tideCategory3Warning
	$VBoxContainer/Category3/CenterContainer3/Category3Value.text = str(UpdateWeather.tideCategory3Warning) + " FT"
	
	$VBoxContainer/Category4/CenterContainer2/HBoxContainer/Category4Slider.value = UpdateWeather.tideCategory4Warning
	$VBoxContainer/Category4/CenterContainer3/Category4Value.text = str(UpdateWeather.tideCategory4Warning) + " FT"
	
	$VBoxContainer/Category5/CenterContainer2/HBoxContainer/Category5Slider.value = UpdateWeather.tideCategory5Warning
	$VBoxContainer/Category5/CenterContainer3/Category5Value.text = str(UpdateWeather.tideCategory5Warning) + " FT"

func _on_TropicalStormSlider_value_changed(value):
	UpdateWeather.tideTropStormWarning = int(value)
	$VBoxContainer/TropicalStorm/CenterContainer3/TropicalStormValue.text = str(value) + " FT"

func _on_Category1Slider_value_changed(value):
	UpdateWeather.tideCategory1Warning = int(value)
	$VBoxContainer/Category1/CenterContainer3/Category1Value.text = str(value) + " FT"

func _on_Category2Slider_value_changed(value):
	UpdateWeather.tideCategory2Warning = int(value)
	$VBoxContainer/Category2/CenterContainer3/Category2Value.text = str(value) + " FT"

func _on_Category3Slider_value_changed(value):
	UpdateWeather.tideCategory3Warning = int(value)
	$VBoxContainer/Category3/CenterContainer3/Category3Value.text = str(value) + " FT"

func _on_Category4Slider_value_changed(value):
	UpdateWeather.tideCategory4Warning = int(value)
	$VBoxContainer/Category4/CenterContainer3/Category4Value.text = str(value) + " FT"

func _on_Category5Slider_value_changed(value):
	UpdateWeather.tideCategory5Warning = int(value)
	$VBoxContainer/Category5/CenterContainer3/Category5Value.text = str(value) + " FT"
