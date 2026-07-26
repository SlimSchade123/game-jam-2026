class_name Frank_Anims
extends Node2D
@onready var frank_anims: AnimationPlayer = %"Frank Anims"

@onready var normal_pos: Node2D = %Normal_Pos
@onready var charge_pos: Node2D = %Charge_Pos

@onready var right_fa: Sprite2D = $CharacterContainer/Body/Normal_Pos/RightFA
@onready var right_hand: Sprite2D = $CharacterContainer/Body/Normal_Pos/RightHand

func dash():
	if charge_pos.get_child_count() == 0:
		right_fa.reparent(charge_pos)
		right_hand.reparent(charge_pos)
	
	frank_anims.speed_scale = 18
	frank_anims.play("Dash")

func run():
	reset_arms()
	frank_anims.play("Frank_Running")
	frank_anims.speed_scale = 12

func jump():
	reset_arms()
	frank_anims.play("Jump")
	frank_anims.speed_scale = 9

func fall():
	reset_arms()
	frank_anims.play("Fall")
	frank_anims.speed_scale = 9



func reset_arms():
	if normal_pos.get_child_count() == 0:
		right_fa.reparent(normal_pos)
		right_hand.reparent(normal_pos)

func frank_ball():
	reset_arms()
	frank_anims.play("Idle")
