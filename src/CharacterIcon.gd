extends CenterContainer

export (Globals.Crew) var Crewman
export var crew_name : String
export(String, FILE) var image_path

#signal IconSelected
var main

func _ready():
	main = get_tree().get_root().get_node("World")

	find_node("Label_Name").text = crew_name
	find_node("TextureRect").texture = load(image_path)
	pass
	
	
func _on_CenterContainer_gui_input(event):
	if event.button_mask != 0:
		main.crew_selected(Crewman)
	pass # Replace with function body.
