class_name Alien
extends Node

var main
var location : Location
var destination : Location
var dest_time : float
var health : int = 100

func _init(_main, loc : Location):
	main = _main
	location = loc
	pass
	

func _process(delta):
	if health <= 0:
		return
		
	if location.crew.size() > 0:
		destination = null
		dest_time -= delta
		if dest_time <= 0:
			main.combat(location)
			dest_time = 3
		return
		
	if destination == null:
		# Get new dest
		var adj = location.adjacent
		destination = adj[Globals.rnd.randi_range(0, adj.size()-1)]
		dest_time = 12
		#print("New alien dest is " + destination.loc_name)
		
	dest_time -= delta
	if dest_time <= 0:
		var prev_loc = location
		location = destination
		main.alien_moved(prev_loc)
		destination = null
		pass
	pass


