extends VBoxContainer

onready var main = get_tree().get_root().get_node("World")

func _ready():
	pass


func update_menu(location : Location):
	# todo
	pass
	

func _on_GoTo_Button_pressed():
	main.set_menu_mode(Globals.MenuMode.GO_TO)
	pass


func _on_CancelButton_pressed():
	main.set_menu_mode(Globals.MenuMode.NONE)
	pass


func _on_PickupBUtton_pressed():
	main.set_menu_mode(Globals.MenuMode.PICK_UP)
	pass
