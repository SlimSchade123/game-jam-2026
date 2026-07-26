extends Node2D
@onready var fakenstein: RigidBody2D = %Fakenstein
const PLAYER_CHARACTER = preload("uid://4rscnq415aft")
@onready var to_frank: Timer = $Fakenstein/To_Frank
@onready var start: Timer = $Fakenstein/Start

@onready var test_animation: Frank_Anims = $Fakenstein/TestAnimation

var can_frank : bool = false 

func _ready() -> void:
	Stats.launch.connect(launch)

func _process(_delta: float) -> void:
	if fakenstein.linear_velocity.x <= 750 and can_frank:
		spawn_player()
	
	print(fakenstein.linear_velocity.x)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_1"):
		spawn_player()
	if event.is_action_pressed("debug_2"):
		## scale from 3 to like, 7
		## scale from 1 to 5 from 1 to 100, add 2
		launch(10)

func launch(scalar : float):
	start.start(1)
	to_frank.start(10)
	ball_anim()
	var true_scalar : float = (scalar / 20) + 2
	
	var strength : Vector2 = Vector2(3,-0.75)
	fakenstein.apply_torque_impulse(500000)
	fakenstein.apply_central_force(strength * true_scalar * 10000)

func ball_anim():
	test_animation.frank_ball()

func spawn_player():
	var player : CharacterBody2D = PLAYER_CHARACTER.instantiate()
	player.velocity = fakenstein.linear_velocity
	player.global_position = fakenstein.global_position
	hide()
	get_parent().add_child(player)
	
	Stats.change_cam_target.emit(player)
	queue_free()


func _on_to_frank_timeout() -> void:
	spawn_player()


func _on_start_timeout() -> void:
	can_frank = true
