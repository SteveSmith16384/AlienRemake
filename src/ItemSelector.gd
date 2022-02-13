extends VBoxContainer

const button_class = preload("res://ItemButton.tscn")

onready var main = get_tree().get_root().get_node("World")

func update_list(loc : Location):
	for item in loc.items:
		var button = button_class.instance()
		button.item_type = item.type
		button.text = Globals.ItemType.keys()[item.type]
		button.connect("pressed", self, "button_pressed")
		add_child(button)
	pass
	
	
func button_pressed(item_type):
	main.item_selected(item_type)
	pass
	


func _on_Cancel_pressed():
	main.cancel_selection()
	pass

