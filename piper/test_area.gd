class_name Enemy2
extends Area2D

@export var collision_info : enemy_collision_info

func _ready() -> void:
	Chris_Singleton.enemy_killed.connect(death)
	new_instance()

func new_instance():
	## updating info of collision info 
	
	collision_info.contact_point = position
	collision_info.enemy_instance = self

func properties():
	## this should parse the collision info for enemy information
	## 
	pass

func _on_body_entered(_body: Node2D) -> void:
	Chris_Singleton.enemy_collided.emit(collision_info)

func death(instance : Enemy2):
	if instance == self:
		print("BLOWING UP: ", instance)
		queue_free()
