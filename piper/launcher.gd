extends Node2D
@onready var fakenstein: RigidBody2D = %Fakenstein
const PLAYER_CHARACTER = preload("uid://4rscnq415aft")
@onready var timer: Timer = $Fakenstein/Timer


func _process(delta: float) -> void:
	pass
	#print(fakenstein.linear_velocity)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		spawn_player()
	if event.is_action_pressed("debug_2"):
		## scale from 3 to like, 7
		## scale from 1 to 5 from 1 to 100, add 2
		launch(25)

func launch(scalar : float):
	var true_scalar : float = (scalar / 20) + 2
	
	var strength : Vector2 = Vector2(2,-2)
	fakenstein.apply_central_force(strength * true_scalar * 10000)




func spawn_player():
	var player : CharacterBody2D = PLAYER_CHARACTER.instantiate()
	player.velocity = fakenstein.linear_velocity
	player.global_position = fakenstein.global_position
	hide()
	get_parent().add_child(player)
	
	Stats.change_cam_target.emit(player)
	
