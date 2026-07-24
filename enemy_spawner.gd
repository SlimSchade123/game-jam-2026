extends Node

var enemy = preload("res://chris/enemy.tscn")
var spawn_position : float = 4500
var spawn_offset : float = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn_enemy(Vector2(4500,650))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(position: Vector2) -> void:
	print("Im spawning it rn")
	var instance = enemy.instantiate()
	instance.global_position = position
	add_child(instance)
	print("New Enemy Pos: ", instance.global_position)


func _on_timer_timeout() -> void:
	spawn_position += spawn_offset
	spawn_enemy(Vector2(spawn_position, 650))
