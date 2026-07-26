extends Node2D

var bar_scene = preload("res://chris/bar_menu.tscn") 

@onready var wall : StaticBody2D = $Wall
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Chris_Singleton.leave_bar.connect(leave_bar)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var instance = bar_scene.instantiate()
	add_child(instance)
	

func leave_bar() -> void:
	print("woah im leaving")
	wall.queue_free()
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
