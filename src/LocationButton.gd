extends Button

export var location_id : int

func _on_LocationButton_pressed():
	emit_signal("pressed", location_id)
	pass
