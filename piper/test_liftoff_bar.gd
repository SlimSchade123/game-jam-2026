extends ProgressBar

# alternating inputs at the start
# constantly decreasing amount
# array of curves that the player uses for their initial velocity
# including an instant game over
@onready var lightning_timer: Timer = $"Lightning Timer"
#@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var charging_audio: AudioStreamPlayer = $Charging_Audio
@onready var music: AudioStreamPlayer = %Music
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var right: Sprite2D = $"../Right"
@onready var left: Sprite2D = $"../Left"

var alternating : bool = false
var initial_press : bool = false
var value_increase : float = 5
var input_dir : Vector2 
var is_charging : bool = false

func _ready() -> void:
	right.hide()
	left.hide()
	lightning_timer.start(3.0)

##left is false right is true
func _input(event: InputEvent) -> void:
	if is_charging:

		if !initial_press:
			if event.is_action_pressed("left"):
				left_pressed()
				alternating = false
				initial_press = true
			if event.is_action_pressed("right"):
				right_pressed()
				alternating = true
				initial_press = true
		else:
			input_dir = Input.get_vector("left", "right", "up", "down")
			if event.is_action("left") and alternating and input_dir.x < 0:
				alternate()
				left_pressed()
			if event.is_action("right") and !alternating and input_dir.x > 0:
				alternate()
				right_pressed()

func right_pressed():
	right.texture = load("res://sorsha/Extra_Assets/Button_Down.png")
	left.texture = load("res://sorsha/Extra_Assets/Button_Up.png")

func left_pressed():
	left.texture = load("res://sorsha/Extra_Assets/Button_Down.png")
	right.texture = load("res://sorsha/Extra_Assets/Button_Up.png")

func alternate():
	alternating = !alternating
	value += value_increase

func _process(_delta: float) -> void:
	if is_charging:
	# multiplying by the scaled value so it gets harder and harder
		value -= 0.1 * value / 48
		
	pass


func _on_lightning_timer_timeout() -> void:
	is_charging = !is_charging
	if is_charging:
		left.show()
		right.show()
		charging_audio.play()
		lightning_timer.start(10)
	else:
		## signal to stats here that the cannon has started
		#audio_stream_player.stream = load()
		launch()
		right.hide()
		left.hide()
		music.play()

func launch():
	Stats.launch.emit(value)
	animation_player.play_backwards("fade_in")
