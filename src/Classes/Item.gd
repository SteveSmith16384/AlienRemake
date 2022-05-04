class_name Item
extends Node

var main
var type : int
var item_name : String
var alien_damage: int = 2 # Default
var location_damage: int = 0 # Default
var has_jones = false

func _init(_main, _type : int, loc : int):
	main = _main
	type = _type
	
	match type:
		Globals.ItemType.CAT_BOX:
			item_name = "Cat Box"
		Globals.ItemType.CORPSE:
			pass
		Globals.ItemType.ELECTRIC_PROD:
			item_name = "Electric Prod"
			alien_damage = 7
			location_damage = 10
		Globals.ItemType.FIRE_EXT:
			item_name = "Fire Ext."
			alien_damage = 3
		Globals.ItemType.HARPOON:
			item_name = "Harpoon"
			alien_damage = 30
			location_damage = 20
		Globals.ItemType.INCINERATOR:
			item_name = "Incinerator"
			alien_damage = 15
			location_damage = 20
		Globals.ItemType.LASER:
			item_name = "Las Pistol"
			alien_damage = 7
			location_damage = 15
		Globals.ItemType.NET:
			item_name = "Net"
		Globals.ItemType.SPANNER:
			item_name = "Spanner"
			alien_damage = 3
		Globals.ItemType.TRACKER:
			item_name = "Tracker"
		_:
			if Globals.RELEASE_MODE == false:
				push_error("Unknown type: " + str(type))
	
	# Put them in the location
	main.locations[loc].items.push_back(self)
	pass
	
