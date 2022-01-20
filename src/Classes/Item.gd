class_name Item
extends Node

var main
var id : int
var item_name : String

func _init(_main, _id : int, _name : String, loc : int):
	main = _main
	id = _id
	item_name = _name
	
	# Put them in the location
	main.locations[loc].crew.push_back(self)
	pass
	
