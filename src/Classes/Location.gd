class_name Location
extends Node

var main
var id : int
var loc_name : String
var area #: LocationArea
var damage : float = 0
var prev_damage : int = 0
var fire = false

var items = []
var crew = []
var adjacent = []

func _init(_main, _id : int, _name : String):
	main = _main
	id = _id
	loc_name = _name
	pass
	
	
func _process(delta: float):
	if fire:
		damage += delta
	if damage > 50 and prev_damage < 50:
		damage_effect()
	elif damage < 50 and prev_damage > 50:
		fire = false
		main.update_ui = true
	prev_damage = damage
	pass
	

func damage_effect():
	if id == Globals.Location.ENGINE_1 or id == Globals.Location.ENGINE_2 or id == Globals.Location.ENGINE_3:
		fire = true
		main.update_ui = true
	
	pass
	
	
func update_sprites():
	if area != null:
		area.update_sprites(main.alien.location == self and crew.size() > 0)
	pass


#func update_alien_sprite(b):
#	if area != null:
#		area.update_alien_sprite(b and crew.size() > 0)
#	pass
