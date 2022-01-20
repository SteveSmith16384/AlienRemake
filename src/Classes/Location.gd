class_name Location
extends Node

var id : int
var loc_name : String
var area #: LocationArea

var items = []
var crew = []
var adjacent = []

func _init(_id : int, _name : String):
	id = _id
	loc_name = _name
	pass
	
