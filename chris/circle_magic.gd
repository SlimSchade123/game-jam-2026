extends Control

@export var circles : Array[Sprite2D]

const small_circle_size = Vector2(8, 6)
const big_circle_size = Vector2(30, 22)


func _process(delta: float) -> void:
	for circle in circles:
		circle.scale += Vector2(0.1, 0.1)

	new_circle(circles[3])

func new_circle(circle : Sprite2D):
	if (circle.scale > big_circle_size):
		var big_circle = circles.pop_back()
		big_circle.scale = small_circle_size
		big_circle.get_parent().move_child(big_circle, 3)
		circles.push_front(big_circle)
