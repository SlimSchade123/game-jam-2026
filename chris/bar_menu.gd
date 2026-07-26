extends CanvasLayer

#INCREASE MAX SPEED
#ANOTHER DASH
#DECREASES START THINGY

var upgrade_cost : int = 50

# 3 tiers
var upgrade_tier : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Increase Max Speed
func _on_left_button_pressed() -> void:
	if Stats.coins_collected > upgrade_cost:
		Stats.upgrade_max_speed += 100 * (upgrade_tier * 50)
		
	pass # Replace with function body.


func _on_middle_button_pressed() -> void:
	if Stats.coins_collected > upgrade_cost:
		Stats.dashes_amount += 1 * upgrade_tier
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	if Stats.coins_collected > upgrade_cost:
		Stats.liftoff_max -= 10
