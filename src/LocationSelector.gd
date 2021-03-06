extends Node2D

const button_class = preload("res://LocationButton.tscn")

onready var main = get_tree().get_root().get_node("World")

func update_list(loc : Location):
	for c in $VBoxContainer.get_children():
		if c.text != "CANCEL":
			c.queue_free()
		pass
		
	for adj in loc.adjacent:
		var button = button_class.instance()
		button.location_id = adj.id
		button.text = Globals.Location.keys()[adj.id]
		button.connect("pressed", self, "button_pressed")
		$VBoxContainer.add_child(button)
	pass
	
	
func button_pressed(loc_id):
	$AudioStreamPlayer_Click.play()
	main.location_selected(loc_id)
	pass
	


func _on_Cancel_pressed():
	$AudioStreamPlayer_Click.play()
	main.cancel_selection()
	pass
