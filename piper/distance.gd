extends Label

var time_text : String = "Distance per second: "
var stored_dist : float = 0

#func _process(delta: float) -> void:
	


func _on_timer_timeout() -> void:
	
	## check the current total distance
	## compare to total distance stored from last second
	Stats.speed = Stats.total_distance - stored_dist
	print("dist per second: ", Stats.speed)
	text = str(time_text, Stats.total_distance - stored_dist)
	stored_dist = Stats.total_distance
