extends CenterContainer

export (Globals.Crew) var Crewman
export var crew_name : String
export(String, FILE) var image_path

onready var main = get_tree().get_root().get_node("World")

func _ready():
	find_node("Label_Name").text = crew_name
	find_node("TextureRect").texture = load(image_path)
	find_node("Label_Status").text = ""
	find_node("SelectedSprite").visible = false
	pass
	
	
func _on_CenterContainer_gui_input(event):
	if event.button_mask != 0:
		$AudioStreamPlayer_Click.play()
		main.crew_selected(Crewman)
	pass


func update_status():
	var crew : Crewman = main.crew[Crewman]
	if crew.health <= 0:
		self.visible = false
		return
		
	$VBoxContainer/Label_Status.text = ""
	$VBoxContainer/SelectedSprite.visible = main.selected_crewman == crew
	if crew.destination != null:
		$VBoxContainer/Label_Status.text = "Walking"
	pass
	
	
