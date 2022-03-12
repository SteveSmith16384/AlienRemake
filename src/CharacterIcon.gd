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
	if event.is_pressed():
		if event.button_mask != 0:
			$AudioStreamPlayer_Click.play()
			main.crew_selected(Crewman)
	pass


func update_status():
	var crew : Crewman = main.crew[Crewman]
	if crew.health <= 0 or crew.in_cryo:
		self.visible = false
		return
	if crew.is_android and main.android_activated:
		self.visible = false
		return
		
	$VBoxContainer/SelectedSprite.visible = main.selected_crewman == crew
	if main.alien != null and crew.location == main.alien.location:
		$VBoxContainer/Label_Status.text = "CAN SEE\nALIEN"
		$VBoxContainer/Label_Status.add_color_override("font_color", Color.red)
	elif main.android_activated and crew.location == Globals.android.location and Globals.android.health > 0:
		$VBoxContainer/Label_Status.text = "CAN SEE\nANDROID"
		$VBoxContainer/Label_Status.add_color_override("font_color", Color.red)
	elif main.jones != null and crew.location == main.jones.location:
		$VBoxContainer/Label_Status.text = "CAN SEEN\nJONES"
		$VBoxContainer/Label_Status.add_color_override("font_color", Color.yellow)
	elif crew.destination != null:
		$VBoxContainer/Label_Status.text = "Walking\n"
		$VBoxContainer/Label_Status.add_color_override("font_color", Color.white)
	else:
		$VBoxContainer/Label_Status.text = "\n"
	pass
	
	
