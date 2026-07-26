extends Control

@export var circles : Array[Sprite2D]

const small_circle_size = Vector2(8, 6)
const big_circle_size = Vector2(46.5, 35.5)
#22 / 4 = 5.5
#16 / 4 = 4.5

func _process(delta: float) -> void:
	for circle in circles:
		var circle_scale = circle.scale + Vector2(5, 5) * delta
		circle.scale = circle_scale
		new_circle(circle)


func new_circle(circle : Sprite2D):
	if (circle.scale >= big_circle_size):
		var big_circle = circles.pop_back()
		big_circle.scale = small_circle_size
		big_circle.get_parent().move_child(big_circle, len(circles) )
		circles.push_front(big_circle)
