extends Node2D

onready var main = get_tree().get_root().get_node("World")

func update_list(location: Location):
	$VBoxContainer/OpenAirlock1.visible = location.id == Globals.Location.CORRIDOR_6 
	$VBoxContainer/OpenAirlock2.visible = location.id == Globals.Location.CORRIDOR_6 
	$VBoxContainer/EnterHypersleep.visible = location.id == Globals.Location.CRYO_VAULT 
	$VBoxContainer/LaunchNarcissus.visible = location.id == Globals.Location.SHUTTLE_BAY 
	$VBoxContainer/StartAutoDestruct.visible = true #location.id == Globals.Location.COMMAND_CENTER 
	$VBoxContainer/StopAutoDestruct.visible = location.id == Globals.Location.COMMAND_CENTER 
	pass
	
	
func _on_CancelButton_pressed():
	$AudioStreamPlayer_Click.play()
	main.cancel_selection()
	pass


func _on_StartAutoDestruct_gui_input(event):
	if event.is_pressed():
		if event.button_mask != 0:
			$AudioStreamPlayer_Click.play()
			main.start_autodestruct()
	pass


func _on_LaunchNarcissus_gui_input(event):
	if event.is_pressed():
		if event.button_mask != 0:
			$AudioStreamPlayer_Click.play()
			main.launch_narcissus()
	pass


func _on_OpenAirlock1_gui_input(event):
	if event.is_pressed():
		if event.button_mask != 0:
			$AudioStreamPlayer_Click.play()
			main.open_airlock1()
	pass


func _on_OpenAirlock2_gui_input(event):
	if event.is_pressed():
		if event.button_mask != 0:
			$AudioStreamPlayer_Click.play()
			main.open_airlock2()
	pass


func _on_EnterHypersleep_gui_input(event):
	if event.is_pressed():
		if event.button_mask != 0:
			$AudioStreamPlayer_Click.play()
			main.enter_hypersleep()
	pass


func _on_StopAutoDestruct_gui_input(event):
	if event.is_pressed():
		if event.button_mask != 0:
			$AudioStreamPlayer_Click.play()
			main.stop_autodestruct()
	pass
