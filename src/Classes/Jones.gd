class_name Jones
extends Node

var main
var location : Location
var dest_time : float
var caught_in # Item
var can_sense_alien = false

func _init(_main, loc : Location):
	main = _main
	location = loc
	pass
	

func _process(delta):
	if caught_in != null:
		return
		
	dest_time -= delta
	if dest_time <= 0:
		var adj = location.adjacent
		location = adj[Globals.rnd.randi_range(0, adj.size()-1)]
		main.jones_moved()
		dest_time = 7
		pass
	pass
