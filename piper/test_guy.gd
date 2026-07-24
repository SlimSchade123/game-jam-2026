extends CharacterBody2D

@onready var dash_timer: Timer = $Dash_Timer
@onready var fall_delay_timer: Timer = $Fall_Delay_Timer


## Speed max should come in tiers
## Each area should act as a 'reset'
## Where you're put back to your normal speed
## Afterwards you can build up to the individual tier of max_speed

@export var true_max_speed : Array[float]
## goes from 1, 2, then 3. maybe 4 at the end of 3 for a cool moment?
var current_speed_tier : int = 1
var max_speed : float = 1200.0
const cust_grav : Vector2 =  Vector2(0, 3000.0)
# basic physics junk
const acceleration : float = 12.5
#const friction : float = 4.5
#var motion : Vector2 = Vector2.ZERO

## used to store momentum for things like hitpausing or the speak easy if we choose to do all that
var stored_velocity : Vector2 
var start_position : Vector2 = Vector2.ZERO

enum Player_State { neutral = 0, run_one = 1, run_two = 2, jump_one = 3, jump_two = 4, strapped = 5, launched = 6, cutscene = 7, dashed = 8}
var current_state : Player_State = Player_State.strapped

## anything pertaining to the dash
var dash_on_cooldown : bool = false
var is_dashing : bool = false

var dash_length : float = 0.8
var dash_fall_length : float = 0.4
var fall_delay : bool = false
var dash_cooldown : float = 1.5
var remaining_dashes : int = 1
var fall_speed_scalar : float = 1.0
## for use with cameras

## need to get rid of, but its here for now -w-
var x_input : float = 1

## jump info
var jumped : bool = false
const jump_velocity : float = -1150

func _ready() -> void:
	start_position = position
	Chris_Singleton.enemy_collided.connect(enemy_collided)

func enemy_collided(_info : enemy_collision_info) -> void:
	print("Coming to you soon...")

func _physics_process(delta: float) -> void:
	Stats.total_distance = absf(start_position.x - position.x) 
	
	falling(delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		current_state_update(Player_State.jump_one)
	
	if Input.is_action_just_pressed("dash") and !dash_on_cooldown:
		current_state_update(Player_State.dashed)
	
	
	## this controls the momentum rn, idk if itll be necessary
	var velocity_weight : float = delta * acceleration
	
	## acceleration needs to be scaled by the current combo and deceleration timer thing whenever i do that
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	current_state_behavior(current_state)
	move_and_slide()

#region State Machine

func current_state_update(new_state : Player_State):
	## function exists incase we need individual setter behaviors
	current_state = new_state

## This function exists in physics_process
## Assigns behaviors to states
func current_state_behavior(state : Player_State):
	match state:
		Player_State.neutral:
			running()
			## basic run
			pass
		Player_State.jump_one:
			jump()
		Player_State.run_one:
			# run on stage 2
			pass
		Player_State.run_two:
			# run on stage 3
			pass
		Player_State.launched:
			# after the lightning, ala castle crashers
			# set a timer, once you're done bouncing you go to neutral run with some high speed
			pass
		Player_State.strapped:
			pass
			# before lightning during the charge up
			# do nothing 
		Player_State.dashed:
			dash()
		## update player state exclusively here
		pass

#endregion State Machine

func running():
	pass

func forwards_momentum():
	pass

#region Dashing

func dash():
	## turn me red
	if !is_dashing:
		fall_delay = true
		is_dashing = true
		fall_speed_scalar = 0.4
		Stats.dashing.emit(true)
		modulate = Color(0.0, 0.816, 1.0, 1.0)
		max_speed = max_speed * 1.2
		dash_on_cooldown = true
		dash_timer.start(dash_length)
		fall_delay_timer.start(dash_fall_length)


func _on_dash_timer_timeout() -> void:
	if is_dashing:
		Stats.dashing.emit(false)
		current_state_update(Player_State.neutral)
		## turn me normal
		modulate = Color(0.785, 0.785, 0.785, 1.0)
		is_dashing = false
		dash_timer.start(dash_cooldown)
	else:
		dash_on_cooldown = false
		dash_recharge()

func dash_recharge():
	modulate = Color(0.944, 0.944, 0.944, 1.0)
	## make character flash briefly
	print("dash ready ! !")

func _on_fall_delay_timer_timeout() -> void:
	## enables a boolean so that gravity starts applying again after a dash
	fall_delay = false


#endregion Dashing

#region Jumping

## jump information
func jump():
	if !jumped:
		velocity.y = jump_velocity
		jumped = true
	## jump should happen super super quickly
	## jump should stall if input continues to be held, dampening gravity at the peak of the jump
	## once jump is finished, gravity should add exponentially until grounded.
	pass


func falling(delta: float):
	## come back to this with air stalling and exponential weight
	if is_dashing and fall_delay:
		## should stall in the air 
		velocity.y = 0
		# should curve back to normal gravity after a moment
		pass
	else:
		
		if not is_on_floor():
			velocity += cust_grav * delta * fall_speed_scalar
		else:
			## on the floor
			fall_speed_scalar = 1
			current_state_update(Player_State.neutral)
			jumped = false

#endregion Jumping
