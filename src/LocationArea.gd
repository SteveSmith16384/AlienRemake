extends Area2D

export (Globals.Location) var location_id

var main
var location : Location

func _ready():
	main = get_tree().get_root().get_node("World")
	
#	location = main.locations[location_id]
	pass
	
	
func _on_LocationArea_mouse_entered():
	if location == null:
		location = main.locations[location_id]
		
	$Label_Name.text = location.loc_name
	pass # Replace with function body.


func _on_LocationArea_mouse_exited():
	$Label_Name.text = ""
	pass # Replace with function body.
