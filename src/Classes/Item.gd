class_name Item
extends Node

var main
var type : int
var item_name : String

func _init(_main, _type : int, _name : String, loc : int):
	main = _main
	type = _type
	item_name = _name
	
	# Put them in the location
	main.locations[loc].items.push_back(self)
	pass
	
