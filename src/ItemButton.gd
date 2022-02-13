extends Button

export var item_type : int

func _on_ItemButton_pressed():
	emit_signal("pressed", item_type)
	pass
