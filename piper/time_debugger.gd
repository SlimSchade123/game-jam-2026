extends Label

var time_text : String = "Time: "

func _process(delta: float) -> void:
	Stats.total_time += delta
	text = str(time_text, Stats.total_time)
