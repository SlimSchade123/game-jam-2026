extends Node2D

@export var current_pcam : PhantomCamera2D

var target_offset : Vector2
var target_length : float = 0.8
var tween : Tween

func _ready() -> void:
	Stats.dashing.connect(adjust_pcam)

func adjust_pcam(is_dashing : bool):
	## sets the offset 
	if is_dashing:
		target_offset = Vector2(600, 0)
		target_length = 0.25
	else:
		target_offset = Vector2(800, 0)
		target_length = 2.0
	tween_offset()


func reset_tween():
	if tween:
		tween.kill()
	tween = create_tween()

func tween_offset():
	reset_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(current_pcam, "follow_offset", target_offset, target_length)
