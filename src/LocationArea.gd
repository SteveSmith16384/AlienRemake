extends Area2D

export (Globals.Location) var location_id

onready var main = get_tree().get_root().get_node("World")
var location : Location

func _ready():
	$Crewman_Sprite.visible = false
	$Crewman_Sprite_Faded.visible = false
	$Alien_Sprite.visible = false
	$Fire_Sprite.visible = false
	pass
	
	
func _process(_delta):
	if location == null:
		location = main.locations[location_id]
		location.area = self
	pass
	
	
func update_sprites(show_alien):
	$Crewman_Sprite.visible = false
	$Crewman_Sprite_Faded.visible = false
	
	if location.crew.has(main.selected_crewman):
		$Crewman_Sprite.visible = true
	elif location.crew.size() > 0:
		$Crewman_Sprite_Faded.visible = true

	$Fire_Sprite.visible = location.fire

	$Alien_Sprite.visible = true#show_alien
	if show_alien:
		$AudioStreamPlayer_Alien.play()
	pass
	
	
#func update_alien_sprite(b):
#	pass
	
	
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
		if event.button_mask == 1:
			$AudioStreamPlayer_Click.play()
			main.location_selected(location_id)
		elif event.button_mask == 2:
			$AudioStreamPlayer_Click.play()
			main.location_selected(location_id, true)
	pass
