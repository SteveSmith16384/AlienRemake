extends Node2D

onready var main = get_tree().get_root().get_node("World")

func update_list(location: Location):
	$VBoxContainer/OpenAirlock1.visible = location.id == Globals.Location.CORRIDOR_6 
	$VBoxContainer/OpenAirlock2.visible = location.id == Globals.Location.CORRIDOR_6 
	$VBoxContainer/EnterHypersleep.visible = location.id == Globals.Location.CRYO_VAULT 
	$VBoxContainer/LaunchNarcissus.visible = location.id == Globals.Location.SHUTTLE_BAY 
	$VBoxContainer/StartAutoDestruct.visible = location.id == Globals.Location.COMMAND_CENTER 
	pass
	
	
func _on_OpenAirlock1_pressed():
	$AudioStreamPlayer_Click.play()
	main.open_airlock1()
	pass


func _on_OpenAirlock2_pressed():
	$AudioStreamPlayer_Click.play()
	main.open_airlock2()
	pass


func _on_EnterHypersleep_pressed():
	$AudioStreamPlayer_Click.play()
	main.enter_hypersleep()
	pass


func _on_LaunchNarcissus_pressed():
	$AudioStreamPlayer_Click.play()
	main.launch_narcissus()
	pass


func _on_StartAutoDestruct_pressed():
	$AudioStreamPlayer_Click.play()
	main.start_autodestruct()
	pass


func _on_CancelButton_pressed():
	$AudioStreamPlayer_Click.play()
	main.cancel_selection()
	pass


func _on_StopAutoDestruct_pressed():
	$AudioStreamPlayer_Click.play()
	main.stop_autodestruct()
	pass
