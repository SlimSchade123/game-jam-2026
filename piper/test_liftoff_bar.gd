extends ProgressBar

# alternating inputs at the start
# constantly decreasing amount
# array of curves that the player uses for their initial velocity
# including an instant game over
@onready var lightning_timer: Timer = $"Lightning Timer"
#@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var charging_audio: AudioStreamPlayer = $Charging_Audio
@onready var music: AudioStreamPlayer = %Music

var alternating : bool = false
var initial_press : bool = false
var value_increase : float = 5
var input_dir : Vector2 
var is_charging : bool = false

func _ready() -> void:
	lightning_timer.start(5.0)

##left is false right is true
func _input(event: InputEvent) -> void:
	if is_charging:
		if !initial_press:
			if event.is_action_pressed("left"):
				alternating = false
				initial_press = true
			if event.is_action_pressed("right"):
				alternating = true
				initial_press = true
		else:
			input_dir = Input.get_vector("left", "right", "up", "down")
			if event.is_action("left") and alternating and input_dir.x < 0:
				alternate()
			if event.is_action("right") and !alternating and input_dir.x > 0:
				alternate()

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
		charging_audio.play()
		lightning_timer.start(10)
	else:
		#audio_stream_player.stream = load()
		music.play()
