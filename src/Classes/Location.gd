class_name Location
extends Node

var id : int
var loc_name : String
var area #: LocationArea
var damage : int = 0

var items = []
var crew = []
var adjacent = []

func _init(_id : int, _name : String):
	id = _id
	loc_name = _name
	pass
	
	
func _process(delta: float):
	# todo - check damage
	pass
	
	
func update_crewman_sprite():
	if area != null:
		area.update_crewman_sprite()
	pass


func update_alien_sprite(b):
	if area != null:
		area.update_alien_sprite(b and crew.size() > 0)
	pass
