extends Area2D

export (Globals.Location) var location_id

var main
var location : Location

var blip_scale : float = 1
var blip_diff : int = 1

func _ready():
	main = get_tree().get_root().get_node("World")
	pass


func _process(delta):
	if location == null:
		location = main.locations[location_id]
		location.area = self

	if $Crewman_Sprite.visible:
		blip_scale = blip_scale + (delta * blip_diff * 1.5)
		if blip_scale < 0.5:
			blip_scale = 0.5
			blip_diff = 1
		elif blip_scale > 1:
			blip_scale = 1
			blip_diff = -1
			
		var sprite = $Crewman_Sprite
		sprite.scale.x = blip_scale
		sprite.scale.y = blip_scale
	pass
	
	
func update_crewman_sprite():
	$Crewman_Sprite.visible = location.crew.size() > 0
	pass
	
	
func _on_LocationArea_mouse_entered():
	if location == null:
		return
	$Label_Name.text = location.loc_name
	pass


func _on_LocationArea_mouse_exited():
	$Label_Name.text = ""
	pass


func _on_LocationArea_input_event(viewport, event : InputEvent, shape_idx):
	if event.is_pressed():
		if event.button_mask != 0:
			main.location_selected(location_id)
	pass
