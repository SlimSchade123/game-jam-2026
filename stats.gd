extends Node

## works to track all global or per run stats
## bad architecture, but its game jam and fast !
var total_time : float = 0.0
var total_distance : float = 0.0
var volume : float = 0.5
var coins_collected : int = 100
var speed : float = 0

# Bar Upgrade Stuffs
var upgrade_max_speed: float = 0
var dashes_amount: int = 1
var liftoff_max: int = 100

signal dashing(is_dashing : bool)
signal change_cam_target
signal enemy_killed
signal bar_entered
signal bar_exited


func reset():
	total_time = 0.0
	total_distance = 0.0
	volume = 0.5
	coins_collected = 100
	speed = 0
	upgrade_max_speed = 0
	dashes_amount = 1
	liftoff_max = 100

signal launch(strength : float)
##exists to remove warnings -w-
func bucket():
	dashing.emit()
	launch.emit()
	change_cam_target.emit()
	enemy_killed.emit()
