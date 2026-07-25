extends CanvasLayer

#iNCREASE MAX SPEED
#ANOTHER DASH
#DECREASES START THINGY

var upgrade_cost : int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Increase Max Speed
func _on_left_button_pressed() -> void:
	if Stats.coins_collected > upgrade_cost:
		print("Can Upgrade")
		Stats.upgrade_max_speed += 100
		queue_free()
		
	pass # Replace with function body.


func _on_middle_button_pressed() -> void:
	if Stats.coins_collected > upgrade_cost:
		print("Can Upgrade")
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	if Stats.coins_collected > upgrade_cost:
		print("Can Upgrade")
	pass # Replace with function body.
