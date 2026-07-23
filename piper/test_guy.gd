extends CharacterBody2D


const max_speed : float = 1200.0
const jump_velocity : float = -400.0

# basic physics junk
const acceleration : float = 12.5
const friction : float = 4.5
var motion : Vector2 = Vector2.ZERO

## used to store momentum for things like hitpausing or the speak easy if we choose to do all that
var stored_velocity : Vector2 

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var x_input : float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight : float = delta * (acceleration if x_input else friction)
	
	if Input.is_action_just_pressed("confirm") and is_on_floor():
		velocity.y = jump_velocity
	
	## there should be staged timers, unlocking a higher maximum per stage
	## might be a good idea to have line be the reference here
	## different upgrades could swap out the line on lift_off()
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	print(velocity.x)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * speed	
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
