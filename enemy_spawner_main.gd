extends Node
@onready var spawn_timer: Timer = $"Spawn Timer"


## base prefab used for making new enemies
@export var enemy_info : Array[enemy_collision_info]
## basic array logic int
var enemy_index : int = 0

var enemy_ref = preload("res://piper/enemy_v2.tscn")
var spawn_position : float = 4500

var stored_offset : float = 0
var spawn_offset : float = 1200

## scalar for interval between enemies per layer
## 1.0 should be layer 3, fiddle for each layer instance
@export var spawn_rate : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Chris_Singleton.enemy_collided.connect(update_offset)
	Chris_Singleton.max_speed_changed.connect(update_offset)

func update_offset(_enemy_stats: enemy_collision_info):
	## need to parse max speed from enemy info
	## default offset is 1200, use that as lower bounds potentially
	## upper bounds should be double 1200, so 2400
	
	#	text = str(time_text, Stats.total_distance - stored_dist)
	#	stored_dist = Stats.total_distance
	spawn_offset = Stats.total_distance - stored_offset
	stored_offset = Stats.total_distance
	spawn_offset = maxf(stored_offset, 1200) ## either every 1200, minimum, or whatever the current max speed is
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
