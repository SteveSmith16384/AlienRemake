extends Node2D


func update_statuses():
	for i in $HBoxContainer.get_children():
		i.update_status()
	pass
	
