class_name Enemy2
extends Area2D
@onready var npc_animation: Npc_Anims = $NPC_ANIMATION

@export var collision_info : enemy_collision_info
@onready var bye_bye_timer: Timer = $"bye bye timer"
@onready var help_dude_lol: Timer = $"help dude LOL"

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
	npc_animation.pushed()
	Chris_Singleton.enemy_collided.emit(collision_info)

func death(instance : Enemy2):
	if instance == self:
		npc_animation.killed()
		bye_bye_timer.start(5)



func _on_bye_bye_timer_timeout() -> void:
	queue_free()


func _on_help_dude_lol_timeout() -> void:
	npc_animation.normal()


func _on_kills_self_timeout() -> void:
	queue_free()
	pass # Replace with function body.
