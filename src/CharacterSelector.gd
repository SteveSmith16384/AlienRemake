extends Node2D


#signal CrewSelected


#func _on_IconSelected(crewman):
#	for c in $HBoxContainer.get_children():
#		c.find_node("SelectedSprite").visible = false
#	emit_signal("CrewSelected", crewman)
#	pass


func update_statuses():
	for i in $HBoxContainer.get_children():
		i.update_status()
	pass
	

#func clear_all():
#	for c in $HBoxContainer.get_children():
#		c.find_node("SelectedSprite").visible = false
#	pass
	
