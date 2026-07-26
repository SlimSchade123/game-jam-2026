extends Node
@onready var spawn_timer: Timer = $"Spawn Timer"

@export var timer : Timer
const bar_prefab = preload("res://chris/bar.tscn")

## base prefab used for making new enemies
@export var enemy_info : Array[enemy_collision_info]
## basic array logic int
var enemy_index : int = 0

var enemy_ref = preload("res://piper/enemy_v2.tscn")
var spawn_position : float = 4500

var stored_offset : float = 0
var spawn_offset : float = 1200

var spawn_distance = [25_000, 50_000, 100_000, 200_000]
var spawn_tier = 0
const win_screen = preload("res://chris/win_screen.tscn")

## scalar for interval between enemies per layer
## 1.0 should be layer 3, fiddle for each layer instance
@export var spawn_rate : float = 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_win"):
		print("wowie")
		var instance = win_screen.instantiate()
		add_child(instance)

func spawn_bar():
	
	if Stats.total_distance > spawn_distance[spawn_tier]:
		
		timer.stop()
		if spawn_tier == 3:
			print("OMG YOU WON")
			var instance = win_screen.instantiate()
			add_child(instance)
		
		else:
			print("Oh im spawning it rn ;()")
			
			var instance = bar_prefab.instantiate().duplicate()
			instance.global_position = Vector2(spawn_distance[spawn_tier] + (spawn_offset * 2), 650)
			add_child(instance)
			spawn_tier += 1


func _process(delta: float) -> void:
	spawn_bar()
	pass



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Chris_Singleton.max_speed_changed.connect(update_offset)

func update_offset(max_speed: float):
	## need to parse max speed from enemy info
	## default offset is 1200, use that as lower bounds potentially
	## upper bounds should be double 1200, so 2400
	
	#	text = str(time_text, Stats.total_distance - stored_dist)
	#	stored_dist = Stats.total_distance
	
	
	spawn_offset = maxf(max_speed * randf_range(0.8, 3), 1200)
	#print("Spawn Offset: ", spawn_offset)

func spawn_enemy(position: Vector2) -> void:
	Chris_Singleton.new_enemy()
	## update to go through a list of resources, and spawn the new enemies as they come in
	var instance : Enemy2 = enemy_ref.instantiate()
	instance.global_position = position
	assign_info(instance)
	add_child(instance)
	#print("New Enemy Pos: ", instance.global_position)

func assign_info(instance : Enemy2):
	if enemy_index >= enemy_index:
		enemy_index = 0
	
	instance.collision_info = enemy_info[enemy_index].duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	enemy_index += 1


func _on_timer_timeout() -> void:
	spawn_position += spawn_offset * spawn_rate
	spawn_enemy(Vector2(spawn_position, 650))
