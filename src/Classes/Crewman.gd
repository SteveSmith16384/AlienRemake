class_name Crewman
extends Node

var main
var id : int
var crew_name : String
var location #_id : int
var destination
var dest_time : float
var carrying = []

func _init(_main, _id : int, _name : String, loc : int):
	main = _main
	id = _id
	crew_name = _name
	location = main.locations[loc]
	
	# Put them in the location
	main.locations[loc].crew.push_back(self)
	pass
	

func set_dest(loc):
	if destination == null:
		destination = loc
		dest_time = 10
		return true
	else:
		return false
	pass
	
	
func _process(delta):
	if destination != null:
		dest_time -= delta
		if dest_time <= 0:
			location = destination
			destination = null
			main.crewman_arrived(self)
		pass
	pass
	
	
