class_name Alien
extends Node

var main
var location : Location
var destination : Location
var action_time : float
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
		action_time -= delta
		if action_time <= 0:
			main.combat(location)
			action_time = 3
		return
		
	if destination == null:
		# Get new dest
		var adj = location.adjacent
		destination = adj[Globals.rnd.randi_range(0, adj.size()-1)]
		action_time = 9
		#print("New alien dest is " + destination.loc_name)
		
	action_time -= delta
	if action_time <= 0:
		location = destination
		main.alien_moved()
		destination = null
		pass
	pass


