class_name Crewman
extends Node

var main
var id : int
var crew_name : String
var location_id : int
var carrying = []

func _init(_main, _id : int, _name : String, loc : int):
	main = _main
	id = _id
	crew_name = _name
	location_id = loc
	
	# Put them in the location
	main.locations[loc].crew.push_back(self)
	pass
	
