extends CanvasLayer
@onready var transition_shader: Sprite2D = %"Transition Shader"
@onready var vis_root: Control = $"Vis Root"
@onready var pause_info: Control = $"Vis Root/Pause Info"

var is_paused : bool = false
var tween : Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	pause_info.visible = false
	get_tree().paused = false
	fade_in()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			pause_info.visible = false
			get_tree().paused = false
		else:
			pause_info.visible = true
			get_tree().paused = true

func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()

func fade_in():
	reset_tween()
	tween.tween_property(transition_shader.material, "shader_parameter/radius", 1.55, 2.4)
	await tween.finished
	print("done ! !")
