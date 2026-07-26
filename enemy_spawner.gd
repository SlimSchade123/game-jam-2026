extends Node

var enemy = preload("res://chris/enemy.tscn")


var spawn_position : float = 4500
var spawn_offset : float = 1200



@export var timer : Timer

#Bar Shiii


# Called when the node enters the scene tree for the first time.
func start_spawning_timer():
	timer.start()

func _ready() -> void:
	Chris_Singleton.max_speed_changed.connect(update_offset)
	Chris_Singleton.leave_bar.connect(start_spawning_timer)

func update_offset(max_speed: float):
	spawn_offset = max_speed
	print("Spawn Offset: ", spawn_offset)

func spawn_enemy(position: Vector2) -> void:
	var instance = enemy.instantiate()
	instance.global_position = position

	add_child(instance)
	print("New Enemy Pos: ", instance.global_position)

func _on_timer_timeout() -> void:
	spawn_position += spawn_offset
	spawn_enemy(Vector2(spawn_position, 650))
