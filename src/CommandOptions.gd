extends VBoxContainer

onready var main = get_tree().get_root().get_node("World")

func _ready():
	pass


func update_menu(location : Location, crew: Crewman):
	$PickupButton.visible = location.items.size() > 0 and crew.items.size() < 2
	$DropButton.visible = crew.items.size() > 0
	$UseButton.visible = crew.items.size() > 0
	pass
	

func _on_GoTo_Button_pressed():
	$AudioStreamPlayer_Click.play()
	main.set_menu_mode(Globals.MenuMode.GO_TO)
	pass


func _on_CancelButton_pressed():
	$AudioStreamPlayer_Click.play()
	main.set_menu_mode(Globals.MenuMode.NONE)
	pass


func _on_PickupButton_pressed():
	$AudioStreamPlayer_Click.play()
	main.set_menu_mode(Globals.MenuMode.PICK_UP)
	pass


func _on_UseButton_pressed():
	$AudioStreamPlayer_Click.play()
	main.set_menu_mode(Globals.MenuMode.USE)
	pass


func _on_SpecialButton_pressed():
	$AudioStreamPlayer_Click.play()
	main.set_menu_mode(Globals.MenuMode.SPECIAL)
	pass


func _on_DropButton_pressed():
	$AudioStreamPlayer_Click.play()
	main.set_menu_mode(Globals.MenuMode.DROP)
	pass
