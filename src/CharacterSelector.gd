extends Node2D


signal CrewSelected


func _on_IconSelected(crewman):
	emit_signal("CrewSelected", crewman)
	pass


func update_statuses():
	for i in $HBoxContainer.get_children():
		i.update_status()
	pass
	
