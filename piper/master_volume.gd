extends Control

@onready var master_slider: HSlider = $"Panel3/MarginContainer/VBoxContainer/Master Slider"
@onready var percentage: Label = $Panel3/MarginContainer/VBoxContainer/HSplitContainer/Percentage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.value = Stats.volume
	update_text()

func _on_master_slider_drag_ended(_value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(master_slider.value))
	Stats.volume = master_slider.value
	print(Stats.volume)
	update_text()

func update_text():
	var target_percentage : String = str(Stats.volume * 100)
	percentage.text = str(" %", target_percentage.trim_suffix(".0"))
