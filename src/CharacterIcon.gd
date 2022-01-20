extends CenterContainer

export (Globals.Crew) var Crewman
export var crew_name : String
export(String, FILE) var image_path

signal IconSelected

func _ready():
#	find_node("Label_Name").text = crew_name
#	find_node("TextureRect").texture = load(image_path)
	pass
	
	
func _on_CharacterIcon_gui_input(event):
	if event.button_mask != 0:
		emit_signal("IconSelected", Crewman)
	pass
