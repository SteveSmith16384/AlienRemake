class_name Location
extends Node

var id : int
var loc_name : String
var area #: LocationArea

var items = []
var crew = []
var adjacent = []

func _init(_id : int, _name : String):
	id = _id
	loc_name = _name
	pass
	

func get_item(type) -> Item:
	for item in items:
		if item.type == type:
			return item
	return null
	
	
func remove_item(type):
	for item in items:
		if item.type == type:
			items.erase(item)
	pass

	
func update_crewman_sprite():
	area.update_crewman_sprite()
	pass
