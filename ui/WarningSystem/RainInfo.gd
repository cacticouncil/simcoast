extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/TropicalStorm/CenterContainer2/HBoxContainer/TropicalStormSlider.value = UpdateWeather.rainTropStormWarning
	$VBoxContainer/TropicalStorm/CenterContainer3/TropicalStormValue.text = str(UpdateWeather.rainTropStormWarning) + " FT"
	
	$VBoxContainer/Category1/CenterContainer2/HBoxContainer/Category1Slider.value = UpdateWeather.rainCategory1Warning
	$VBoxContainer/Category1/CenterContainer3/Category1Value.text = str(UpdateWeather.rainCategory1Warning) + " FT"
	
	$VBoxContainer/Category2/CenterContainer2/HBoxContainer/Category2Slider.value = UpdateWeather.rainCategory2Warning
	$VBoxContainer/Category2/CenterContainer3/Category2Value.text = str(UpdateWeather.rainCategory2Warning) + " FT"
	
	$VBoxContainer/Category3/CenterContainer2/HBoxContainer/Category3Slider.value = UpdateWeather.rainCategory3Warning
	$VBoxContainer/Category3/CenterContainer3/Category3Value.text = str(UpdateWeather.rainCategory3Warning) + " FT"
	
	$VBoxContainer/Category4/CenterContainer2/HBoxContainer/Category4Slider.value = UpdateWeather.rainCategory4Warning
	$VBoxContainer/Category4/CenterContainer3/Category4Value.text = str(UpdateWeather.rainCategory4Warning) + " FT"
	
	$VBoxContainer/Category5/CenterContainer2/HBoxContainer/Category5Slider.value = UpdateWeather.rainCategory5Warning
	$VBoxContainer/Category5/CenterContainer3/Category5Value.text = str(UpdateWeather.rainCategory5Warning) + " FT"

func _on_TropicalStormSlider_value_changed(value):
	UpdateWeather.rainTropStormWarning = int(value)
	$VBoxContainer/TropicalStorm/CenterContainer3/TropicalStormValue.text = str(value) + " FT"

func _on_Category1Slider_value_changed(value):
	UpdateWeather.rainCategory1Warning = int(value)
	$VBoxContainer/Category1/CenterContainer3/Category1Value.text = str(value) + " FT"

func _on_Category2Slider_value_changed(value):
	UpdateWeather.rainCategory2Warning = int(value)
	$VBoxContainer/Category2/CenterContainer3/Category2Value.text = str(value) + " FT"

func _on_Category3Slider_value_changed(value):
	UpdateWeather.rainCategory3Warning = int(value)
	$VBoxContainer/Category3/CenterContainer3/Category3Value.text = str(value) + " FT"

func _on_Category4Slider_value_changed(value):
	UpdateWeather.rainCategory4Warning = int(value)
	$VBoxContainer/Category4/CenterContainer3/Category4Value.text = str(value) + " FT"

func _on_Category5Slider_value_changed(value):
	UpdateWeather.rainCategory5Warning = int(value)
	$VBoxContainer/Category5/CenterContainer3/Category5Value.text = str(value) + " FT"
