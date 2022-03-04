class_name Location
extends Node

var id : int
var loc_name : String
var area #: LocationArea
var damage : float = 0
var prev_damage : int = 0
var fire = false

var items = []
var crew = []
var adjacent = []

func _init(_id : int, _name : String):
	id = _id
	loc_name = _name
	pass
	
	
func _process(delta: float):
	if fire:
		damage += delta
	if damage > 50 and prev_damage < 50:
		damage_effect()
	prev_damage = damage
	pass
	

func damage_effect():
	if id == Globals.Location.ENGINE_1 or id == Globals.Location.ENGINE_2 or id == Globals.Location.ENGINE_3:
		fire = true
	pass
	
	
func update_crewman_sprite():
	if area != null:
		area.update_crewman_sprite()
	pass


func update_fire_sprite():
	if area != null:
		area.update_fire_sprite()
	pass


func update_alien_sprite(b):
	if area != null:
		area.update_alien_sprite(b and crew.size() > 0)
	pass
