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
	if damage > 50 and prev_damage <= 50:
		damage_effect()
	elif damage <= 50 and prev_damage > 50:
		fire = false
		main.refresh_ui = true
	elif damage > 99 and prev_damage <= 99:
		terminal_damage()
	prev_damage = damage
	pass
	

func damage_effect():
	if id == Globals.Location.ENGINE_1 or id == Globals.Location.ENGINE_2 or id == Globals.Location.ENGINE_3:
		fire = true
		main.refresh_ui = true
		main.append_log("A fire has started at " + loc_name, Color.red)
	elif id == Globals.Location.CRYO_VAULT:
		main.append_log("Cryogenics malfunction")
	pass
	
	
func terminal_damage():
	if id == Globals.Location.ENGINE_1 or id == Globals.Location.ENGINE_2 or id == Globals.Location.ENGINE_3:
		main.ship_exploded()
	elif id == Globals.Location.CRYO_VAULT:
		main.cryo_destroyed()
	pass

func update_sprites():
	if area != null:
		area.update_sprites(main.alien.location == self and crew.size() > 0)
	pass


#func update_alien_sprite(b):
#	if area != null:
#		area.update_alien_sprite(b and crew.size() > 0)
#	pass
