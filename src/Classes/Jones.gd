class_name Jones
extends Node

var main
var location : Location
var destination : Location
var dest_time : float
var is_in_net: bool = false

func _init(_main, loc : Location):
	main = _main
	location = loc
	pass
	

func _process(delta):
	if is_in_net:
		return
		
	if destination == null:
		# Get new dest
		var adj = location.adjacent
		destination = adj[Globals.rnd.randi_range(0, adj.size()-1)]
		dest_time = 7
		#print("New cat dest is " + destination.loc_name)
		
	dest_time -= delta
	if dest_time <= 0:
		var prev_loc = location
		location = destination
		main.jones_moved()
		destination = null
		pass
	pass
