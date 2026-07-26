extends Node2D

var bar_scene = preload("res://chris/bar_menu.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Im barring it rn")
	var instance = bar_scene.instantiate()
	add_child(instance)
	

func leave_bar() -> void:
	print("woah im leaving")
	Chris_Singleton.leave_bar.emit()
	
