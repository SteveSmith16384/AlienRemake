extends VBoxContainer

var main

func _ready():
	main = get_tree().get_root().get_node("World")
	pass


func update_menu(location : Location):
	# todo
	pass
	

func _on_GoTo_Button_pressed():
	main.set_menu_mode(Globals.MenuMode.GO_TO)
	pass
