class_name Item
extends Node

var main
var type : int
var item_name : String
var weapon_power: int = 2 # Default

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
			weapon_power = 10
		Globals.ItemType.FIRE_EXT:
			item_name = "Fire Ext."
			weapon_power = 5
		Globals.ItemType.HARPOON:
			item_name = "Harpoon"
			weapon_power = 40
		Globals.ItemType.INCINERATOR:
			item_name = "Flamethrower"
			weapon_power = 20
		Globals.ItemType.LASER:
			item_name = "Las Pistol"
			weapon_power = 10
		Globals.ItemType.NET:
			item_name = "Net"
		Globals.ItemType.SPANNER:
			item_name = "Spanner"
			weapon_power = 5
		Globals.ItemType.TRACKER:
			item_name = "Tracker"
		_:
			if Globals.RELEASE_MODE == false:
				push_error("Unknown type: " + str(type))
	
	# Put them in the location
	main.locations[loc].items.push_back(self)
	pass
	
