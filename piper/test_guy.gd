extends CharacterBody2D

@onready var dash_timer: Timer = $Dash_Timer
@onready var fall_delay_timer: Timer = $Fall_Delay_Timer

@onready var frank_vis: Frank_Anims = %Frank_Vis

const LOSE_SCREEN = preload("uid://cu0q7c1cijina")

@onready var scream: AudioStreamPlayer = $scream

var is_drinking : bool = false

var initial_rotation : float = 0
var rot_tween : Tween
var life_tween : Tween
var target_life_time : float = 20
var current_life_time : float = 20
var max_life_time : float = 20 ## the other two reference this chud
## Speed max should come in tiers
## Each area should act as a 'reset'
## Where you're put back to your normal speed
## Afterwards you can build up to the individual tier of max_speed

@export var true_max_speed : Array[float]
## goes from 1, 2, then 3. maybe 4 at the end of 3 for a cool moment?
var current_speed_tier : int = 1
var max_speed_cap : float = 2400
var min_speed_cap : float = 800
var max_speed : float = 1200.0
const cust_grav : Vector2 =  Vector2(0, 3000.0)
# basic physics junk
const acceleration : float = 10
#const friction : float = 4.5
#var motion : Vector2 = Vector2.ZERO

## used to store momentum for things like hitpausing or the speak easy if we choose to do all that
var stored_velocity : Vector2 
var start_position : Vector2 = Vector2.ZERO

enum Player_State { neutral = 0, run_one = 1, run_two = 2, jump_one = 3, jump_two = 4, strapped = 5, launched = 6, cutscene = 7, dashed = 8, dead = 9}
@export var current_state : Player_State = Player_State.strapped

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

## jump info
var jumped : bool = false
const jump_velocity : float = -1150
var speed : float 
# speed meter info
# variants for upgrades
var current_meter_duration : = 20
var meter_duration : float = 20

func _ready() -> void:
	start_position = position
	#spawn_offset = Stats.total_distance - stored_offset
	#stored_offset = Stats.total_distance
	Chris_Singleton.enemy_collided.connect(enemy_collided)
	Stats.bar_entered.connect(start_drinking)
	Stats.bar_exited.connect(end_drinking)
	#rotation_initial_tween()

func post_catapult():
	## set starting speed here
	## range from like, 400 and 1200 for max speed
	## if the catapult returns like, sub 15%
	## 
	pass

func enemy_collided(info : enemy_collision_info) -> void:
	enemy_dashed(info.enemy_instance)

func _physics_process(delta: float) -> void:
	if current_state == Player_State.dead:
		return
	
	Stats.total_distance = absf(start_position.x - position.x) 
	
	falling(delta)
	
	## jump input check
	if Input.is_action_just_pressed("jump") and is_on_floor():
		current_state_update(Player_State.jump_one)
	
	# dash input check
	if Input.is_action_just_pressed("dash") and !dash_on_cooldown:
		current_state_update(Player_State.dashed)
	
	## this controls the momentum rn, idk if itll be necessary
	## need a slight refactor here, momentum doesn't reallllly show in current gameplay
	## 
	
	if Stats.speed < 250:
		var loser := LOSE_SCREEN.instantiate()
		add_child(loser)
		Stats.reset()
		print("dead !!")
	
	current_state_behavior(current_state, delta)
	move_and_slide()

#region State Machine

func current_state_update(new_state : Player_State):
	if current_state != new_state:
		current_state = new_state
		print(current_state)
		
	## function exists incase we need individual setter behaviors

## This function exists in physics_process
## Assigns behaviors to states
func current_state_behavior(state : Player_State, delta : float):
	match state:
		Player_State.neutral:
			#mainly exists for anims
			#frank_vis.run()
			forwards_momentum(delta)
			## basic run
			pass
		Player_State.jump_one:
			jump()
			forwards_momentum(delta)
			
		Player_State.launched:
			# after the lightning, ala castle crashers
			# set a timer, once you're done bouncing you go to neutral run with some high speed
			pass
		Player_State.strapped:
			pass
		Player_State.dashed:
			dash()
			forwards_momentum(delta)
		Player_State.dead:
			death()
		## update player state exclusively here
		pass

func death():
	# gama over
	print("game over !! !")
	pass

#endregion State Machine

func forwards_momentum(delta : float):
	var velocity_weight : float = delta * (acceleration * max(0, (current_life_time / max_life_time)))
	#print("lifetime ratio:", max(0, (current_life_time / max_life_time)))
	var target_speed : float = max_speed * max(0, (current_life_time / max_life_time))
	## acceleration needs to be scaled by the current combo and deceleration timer thing whenever i do that
	velocity.x = lerp(velocity.x, min(target_speed, max_speed_cap), velocity_weight)

#region Dashing

func dash():
	## turn me red
	if !is_dashing:
		frank_vis.dash()
		fall_delay = true
		is_dashing = true
		fall_speed_scalar = 0.4
		Stats.dashing.emit(true)
		modulate = Color(0.0, 0.816, 1.0, 1.0)
		
		dash_on_cooldown = true
		dash_timer.start(dash_length)
		fall_delay_timer.start(dash_fall_length)
		
		scream.pitch_scale = randf_range(0.8, 1.2)
		scream.play()


func enemy_killed():
	max_speed = max_speed * 1.2

func _on_dash_timer_timeout() -> void:
	if is_dashing:
		Stats.dashing.emit(false)
		frank_vis.run()
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
		frank_vis.jump()
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
			if velocity.y < 0 : frank_vis.fall()
			
		else:
			## on the floor
			fall_speed_scalar = 1
			if current_state != Player_State.strapped:
				current_state_update(Player_State.neutral)
				#frank_vis.run()
			if jumped:
				frank_vis.run()
			jumped = false

#endregion Jumping


#region Enemy_Interactions

func enemy_dashed(enemy : Enemy2):
	if is_dashing:
		print("Enemy instance: ", enemy)
		Chris_Singleton.enemy_killed.emit(enemy)
		enemy_killed()
		reset_life_time()
		pass
	pass

#endregion Enemy_Interactions


#region life span

func start_drinking():
	is_drinking = true

func end_drinking():
	reset_life_time()
	is_drinking = false

func _on_life_timer_timeout() -> void:
	
	## decrements life span by 0.5 each time
	
	if !is_drinking:
		target_life_time -= 0.75
		life_time_decrement()

func reset_life_time():
	target_life_time = max_life_time
	## lerp current_life_time to target_life_time
	
	#current_life_time = lerpf(current_life_time, target_life_time, )
	pass

func reset_tween():
	if life_tween:
		life_tween.kill()
	life_tween = create_tween()

func reset_rot():
	if rot_tween:
		rot_tween.kill()
	rot_tween = create_tween()

#func rotation_initial_tween():
	#frank_vis.rotation = initial_rotation
	#rot_tween.tween_property(frank_vis, "rotation", 0, 1)
	#frank_vis.rotation

func life_time_decrement():
	## 1.5 here to give a window of repreive even when the player has technically lost
	reset_tween()
	life_tween.tween_property(self, "current_life_time", target_life_time, 1.5)
	#print("done ! !")

func game_over_check():
	if current_life_time == 0:
		print("GAME OVER")

#endregion life span
