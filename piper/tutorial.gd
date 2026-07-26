extends Label
@onready var timer: Timer = $Timer

var tutorial_step = 0
var tutorial_text = ["Press Shift to dash", "Kill for momentum" ]

func _ready():
	Stats.change_cam_target.connect(start_tutorial)

func set_tutorial_text():
	if tutorial_step == 2:
		queue_free()
		return
	text = tutorial_text[tutorial_step]
	tutorial_step += 1
	print("Tot", tutorial_step)


func _on_timer_timeout() -> void:
	set_tutorial_text()


func start_tutorial(node: Node2D ):
	print("Starting tut")
	timer.start()
	show()
