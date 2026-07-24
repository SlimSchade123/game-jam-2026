extends CharacterBody2D

@onready var dash_timer: Timer = $Dash_Timer


## Speed max should come in tiers
## Each area should act as a 'reset'
## Where you're put back to your normal speed
## Afterwards you can build up to the individual tier of max_speed

@export var true_max_speed : Array[float]
## goes from 1, 2, then 3. maybe 4 at the end of 3 for a cool moment?
var current_speed_tier : int = 1
var max_speed : float = 1200.0
const jump_velocity : float = -1150
const cust_grav : Vector2 =  Vector2(0, 3000.0)
# basic physics junk
const acceleration : float = 12.5
const friction : float = 4.5
var motion : Vector2 = Vector2.ZERO

## used to store momentum for things like hitpausing or the speak easy if we choose to do all that
var stored_velocity : Vector2 
var start_position : Vector2 = Vector2.ZERO

enum Player_State { neutral = 0, run_one = 1, run_two = 2, jump_one = 3, jump_two = 4}
var current_state : Player_State = Player_State.neutral

## anything pertaining to the dash
var dash_on_cooldown : bool = false
var is_dashing : bool = false
var dash_length : float = 0.8
var dash_cooldown : float = 1.5


func _ready() -> void:
	start_position = position

func _physics_process(delta: float) -> void:
	Stats.total_distance = absf(start_position.x - position.x) 
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("dash") and !dash_on_cooldown:
		dash()
	
	#if Input.is_action_pressed("confirm"):
		#print("hover in air for a moment")
	#else:
		#print("stop hover")
	
	#print("current vertical position: ", position.y)
	## start pos 721.9
	## end pos 458.429~
	
	
	if not is_on_floor():
		velocity += cust_grav * delta
	
	#var x_input : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var x_input : float = 1
	var velocity_weight : float = delta * (acceleration if x_input else friction)
	

	
	## there should be staged timers, unlocking a higher maximum per stage
	## might be a good idea to have line be the reference here
	## different upgrades could swap out the line on lift_off()
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	#print(velocity.x)	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * speed	
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func dash():
	max_speed = max_speed * 1.2
	dash_on_cooldown = true
	is_dashing = true
	dash_timer.start(dash_length)

func _on_dash_timer_timeout() -> void:
	if is_dashing:
		is_dashing = false
		dash_timer.start(dash_cooldown)
	else:
		dash_on_cooldown = false
		dash_recharge()

func dash_recharge():
	print("dash ready ! !")
