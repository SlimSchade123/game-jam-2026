extends ProgressBar

# alternating inputs at the start
# constantly decreasing amount
# array of curves that the player uses for their initial velocity
# including an instant game over

var alternating : bool = false
var initial_press : bool = false
var value_increase : float = 5
var input_dir : Vector2 
var charging : bool = true

##left is false right is true
func _input(event: InputEvent) -> void:
	if charging:
		if !initial_press:
			if event.is_action_pressed("left"):
				alternating = false
				initial_press = true
			if event.is_action_pressed("right"):
				alternating = true
				initial_press = true
		else:
			input_dir = Input.get_vector("left", "right", "up", "down")
			if event.is_action_pressed("left") and alternating and input_dir.x < 0:
				alternate()
			if event.is_action_pressed("right") and !alternating and input_dir.x > 0:
				alternate()
			print(input_dir.x)

func alternate():
	alternating = !alternating
	value += value_increase

func _process(delta: float) -> void:
	if charging:
	# multiplying by the scaled value so it gets harder and harder
		value -= 0.1 * value / 32
		
	pass
