extends Label

func _ready() -> void:
	ChrisSingleton.text_test.connect(_change_text)

func _change_text(new_text: String):
	text = new_text
