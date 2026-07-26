class_name Npc_Anims
extends Node2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	animation_player.play("Idle")
	print("playing idle")

func normal():
	animation_player.play("Idle")

func killed():
	animation_player.speed_scale = 10
	animation_player.play("Dash2")

func pushed():
	animation_player.speed_scale = 15
	animation_player.play("hit")
