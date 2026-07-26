extends CanvasLayer

#INCREASE MAX SPEED
#ANOTHER DASH
#DECREASES START THINGY

var upgrade_cost : int = 50

# 3 tiers
var upgrade_tier : int = 0

@export var coin_label : Label

@export var left_button : Button
@export var middle_button : Button
@export var right_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coin_label.text = str("Coins: " , Stats.coins_collected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Increase Max Speed
func _on_left_button_pressed() -> void:
	if Stats.coins_collected >= upgrade_cost:
		Stats.upgrade_max_speed += 100 * (upgrade_tier * 50)
		Stats.coins_collected -= upgrade_cost
		
		coin_label.text = str("Coins: " , Stats.coins_collected)
		left_button.queue_free()

func _on_middle_button_pressed() -> void:
	if Stats.coins_collected >= upgrade_cost:
		Stats.dashes_amount += 1 * upgrade_tier
		Stats.coins_collected -= upgrade_cost
		
		coin_label.text = str("Coins: " , Stats.coins_collected)
		middle_button.queue_free()

func _on_right_button_pressed() -> void:
	if Stats.coins_collected >= upgrade_cost:
		Stats.liftoff_max -= 10
		Stats.coins_collected -= upgrade_cost
		
		coin_label.text = str("Coins: " , Stats.coins_collected)
		right_button.queue_free()


func _on_exit_button_pressed() -> void:
	Chris_Singleton.leave_bar.emit()
	queue_free()
