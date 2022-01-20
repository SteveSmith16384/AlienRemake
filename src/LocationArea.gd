#class_name LocationArea
extends Area2D

export (Globals.Location) var location_id

var main
var location : Location

func _ready():
	main = get_tree().get_root().get_node("World")
	pass


func _process(delta):
	if location == null:
		location = main.locations[location_id]
		location.area = self
	pass
	
	
func _on_LocationArea_mouse_entered():		
	$Label_Name.text = location.loc_name
	pass # Replace with function body.


func _on_LocationArea_mouse_exited():
	$Label_Name.text = ""
	pass # Replace with function body.


func _on_LocationArea_input_event(viewport, event, shape_idx):
	if event.button_mask != 0:
		main.location_selected(location_id)
	pass
