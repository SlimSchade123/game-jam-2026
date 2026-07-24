extends Node2D

@export var collision_info : enemy_collision_info

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "CharacterBody2D":
		return
		
	collision_info.contact_point = position
	collision_info.collision_object = self
	Chris_Singleton.enemy_collided.emit(collision_info)
	print("OMG")
