extends CanvasLayer

@onready var offsetter: Control = $Offsetter
@onready var transition_shader: Sprite2D = %"Transition Shader"


var tween : Tween  
var tween_length : float = 0.8

var is_in_options : bool = false
var target_offset : Vector2 = Vector2(1920, 0)
var original_offset : Vector2 = Vector2.ZERO

func _on_button_pressed() -> void:
	is_in_options = !is_in_options
	## this is the options button
	## to options
	if is_in_options:
		enter_tween_menus(target_offset)
	else:
		enter_tween_menus(original_offset)

func fade_out():
	reset_tween()
	tween.tween_property(transition_shader.material, "shader_parameter/radius", 0, 2.25)
	await tween.finished
	get_tree().change_scene_to_file("uid://bn62q6coy8es0")

func enter_tween_menus(target_position : Vector2):
	reset_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(offsetter, "position", target_position, tween_length)

func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()


func _on_play_button_pressed() -> void:
	fade_out()
