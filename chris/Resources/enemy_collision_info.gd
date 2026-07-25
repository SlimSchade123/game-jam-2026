extends Resource
class_name enemy_collision_info

@export var coins_dropped : int
@export var speed_tier : int

@export var dashable : bool
@export var jumpable : bool
@export var slowdown_rate : float

var contact_point : Vector2
var enemy_instance : Enemy2
var enemy_index : int = 0

# Basic Enemy : Jump & Dash OK
# Mob Enemy : Dash OK
# Fire Hydrant : Jump OK
# Barbed Wire : Nothing OK (possibly stun??)
