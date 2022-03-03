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
var base_morale : int = 100 # Affected by events
var adjusted_morale : int = 100 # Base morale then adjusted by current circumstance

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
	if health <= 0:
		return
		
	if adjusted_morale < 10:
		return
		
	calc_morale()
	if destination != null:
		dest_time -= delta
		if dest_time <= 0:
			location.crew.erase(self)
			#var prev_loc = location
			location = destination
			location.crew.push_back(self)
			destination = null
			main.crewman_moved(self)
		pass
	pass
	
	
func died():
	location.crew.erase(self)
	health = 0

	# Drop all equipment
	location.items.append_array(self.items)
	self.items.clear()
	pass
	

func calc_morale():
	# todo
	pass
	
	
