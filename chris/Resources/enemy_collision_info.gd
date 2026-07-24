extends Resource
class_name enemy_collision_info

@export var coins_dropped : int
@export var speed_tier : int

@export var can_dash : bool
@export var slowdown_rate : float

var contact_point : Vector2
var collision_object : Node2D
