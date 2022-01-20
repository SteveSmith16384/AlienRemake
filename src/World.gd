extends Node2D

var selected_crewman : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_CharacterSelector_CrewSelected(crewman):
	if selected_crewman == crewman:
		return
		
	selected_crewman = crewman
	update_ui()
	pass


func update_ui():
	pass
	
	
