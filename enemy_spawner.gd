extends Node

var enemy = preload("res://chris/enemy.tscn")
const bar_prefab = preload("res://chris/bar.tscn")

var spawn_position : float = 4500
var spawn_offset : float = 1200

var spawn_distance = [10_000, 25_000, 100_000]
var spawn_tier = 0

@export var timer : Timer

#Bar Shiii
func spawn_bar():
	if Stats.total_distance > spawn_distance[spawn_tier]:
		var instance = bar_prefab.instantiate()
		instance.global_position = Vector2(spawn_distance[spawn_tier] + (spawn_offset * 2), 650)
		add_child(instance)
		#print("Oh im spawning it rn ;()")
		
		timer.stop()
		spawn_tier += 1


func _process(delta: float) -> void:
	spawn_bar()
	pass


# Called when the node enters the scene tree for the first time.
func start_spawning_timer():
	timer.start()

func _ready() -> void:
	Chris_Singleton.enemy_collided.connect(update_offset)
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
