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
		$VBoxContainer/Label_Status.text = "ALIEN"
	elif main.android_activated and crew.location == Globals.android.location:
		$VBoxContainer/Label_Status.text = "ANDROID"
	elif main.jones != null and crew.location == main.jones.location:
		$VBoxContainer/Label_Status.text = "JONES"
	elif crew.destination != null:
		$VBoxContainer/Label_Status.text = "Walking"
	else:
		$VBoxContainer/Label_Status.text = ""
	pass
	
	
