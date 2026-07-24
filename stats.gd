extends Node

## works to track all global or per run stats
## bad architecture, but its game jam and fast !
var total_time : float = 0.0
var total_distance : float = 0.0
var volume : float = 0.5


signal dashing(is_dashing : bool)

##exists to remove warnings -w-
func bucket():
	dashing.emit()
