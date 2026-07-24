extends Button

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("OMG")
	ChrisSingleton.text_test.emit("wowie")
	
