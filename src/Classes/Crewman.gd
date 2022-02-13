class_name Crewman
extends Node

var main
var id : int
var crew_name : String
var location : Location
var destination : Location
var dest_time : float
var items = []
var is_android = false
var health : int = 100

func _init(_main, _id : int, _name : String, loc : int):
	main = _main
	id = _id
	crew_name = _name
	location = main.locations[loc]
	
	# Put them in the location
	main.locations[loc].crew.push_back(self)
	pass
	

func set_dest(loc) -> bool:
	if destination == null:
		destination = loc
		dest_time = 10 * 100 / health
		return true
	else:
		return false
	pass
	
	
func _process(delta):
	if destination != null:
		dest_time -= delta
		if dest_time <= 0:
			location.crew.erase(self)
			var prev_loc = location
			location = destination
			location.crew.push_back(self)
			destination = null
			main.crewman_moved(self, prev_loc)
		pass
	pass
	
	
