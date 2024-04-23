extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/TropicalStorm/CenterContainer2/HBoxContainer/TropicalStormSlider.value = UpdateWeather.aneTropStormWarning
	$VBoxContainer/TropicalStorm/CenterContainer3/TropicalStormValue.text = str(UpdateWeather.aneTropStormWarning) + " MPH"
	
	$VBoxContainer/Category1/CenterContainer2/HBoxContainer/Category1Slider.value = UpdateWeather.aneCategory1Warning
	$VBoxContainer/Category1/CenterContainer3/Category1Value.text = str(UpdateWeather.aneCategory1Warning) + " MPH"
	
	$VBoxContainer/Category2/CenterContainer2/HBoxContainer/Category2Slider.value = UpdateWeather.aneCategory2Warning
	$VBoxContainer/Category2/CenterContainer3/Category2Value.text = str(UpdateWeather.aneCategory2Warning) + " MPH"
	
	$VBoxContainer/Category3/CenterContainer2/HBoxContainer/Category3Slider.value = UpdateWeather.aneCategory3Warning
	$VBoxContainer/Category3/CenterContainer3/Category3Value.text = str(UpdateWeather.aneCategory3Warning) + " MPH"
	
	$VBoxContainer/Category4/CenterContainer2/HBoxContainer/Category4Slider.value = UpdateWeather.aneCategory4Warning
	$VBoxContainer/Category4/CenterContainer3/Category4Value.text = str(UpdateWeather.aneCategory4Warning) + " MPH"
	
	$VBoxContainer/Category5/CenterContainer2/HBoxContainer/Category5Slider.value = UpdateWeather.aneCategory5Warning
	$VBoxContainer/Category5/CenterContainer3/Category5Value.text = str(UpdateWeather.aneCategory5Warning) + " MPH"

func _on_TropicalStormSlider_value_changed(value):
	UpdateWeather.aneTropStormWarning = int(value)
	$VBoxContainer/TropicalStorm/CenterContainer3/TropicalStormValue.text = str(value) + " MPH"

func _on_Category1Slider_value_changed(value):
	UpdateWeather.aneCategory1Warning = int(value)
	$VBoxContainer/Category1/CenterContainer3/Category1Value.text = str(value) + " MPH"

func _on_Category2Slider_value_changed(value):
	UpdateWeather.aneCategory2Warning = int(value)
	$VBoxContainer/Category2/CenterContainer3/Category2Value.text = str(value) + " MPH"

func _on_Category3Slider_value_changed(value):
	UpdateWeather.aneCategory3Warning = int(value)
	$VBoxContainer/Category3/CenterContainer3/Category3Value.text = str(value) + " MPH"

func _on_Category4Slider_value_changed(value):
	UpdateWeather.aneCategory4Warning = int(value)
	$VBoxContainer/Category4/CenterContainer3/Category4Value.text = str(value) + " MPH"

func _on_Category5Slider_value_changed(value):
	UpdateWeather.aneCategory5Warning = int(value)
	$VBoxContainer/Category5/CenterContainer3/Category5Value.text = str(value) + " MPH"
