extends Area2D

export (Globals.Location) var location_id

onready var main = get_tree().get_root().get_node("World")
var location : Location

func _ready():
	$Crewman_Sprite.visible = false
	$Alien_Sprite.visible = false
	pass
	
	
func _process(delta):
	if location == null:
		location = main.locations[location_id]
		location.area = self
	pass
	
	
func update_crewman_sprite():
	$Crewman_Sprite.visible = location.crew.size() > 0
	pass
	
	
func update_alien_sprite(b):
	$Crewman_Sprite.visible = b
	pass
	
	
func _on_LocationArea_mouse_entered():
	if location == null:
		return
	$Label_Name.text = location.loc_name
	pass


func _on_LocationArea_mouse_exited():
	$Label_Name.text = ""
	pass


func _on_LocationArea_input_event(_viewport, event : InputEvent, _shape_idx):
	if event.is_pressed():
		if event.button_mask != 0:
			main.location_selected(location_id)
	pass
