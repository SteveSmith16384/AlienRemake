extends Node2D


signal CrewSelected


func _on_IconSelected(crewman):
	emit_signal("CrewSelected", crewman)
	pass
