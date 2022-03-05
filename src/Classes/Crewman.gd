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
var male: bool = true
var in_cryo: bool = false

func _init(_main, _id : int, _name : String, loc : int, _male: bool):
	main = _main
	id = _id
	crew_name = _name
	location = main.locations[loc]
	male = _male
	
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
	
	if has_item(Globals.ItemType.FIRE_EXT) and location.fire:
		location.damage -= delta * 5
		# todo - sfx
		pass
		
	if destination != null:
		dest_time -= delta
		if dest_time <= 0:
			location.crew.erase(self)
			location = destination
			location.crew.push_back(self)
			destination = null
			main.crewman_moved(self)
		pass
	pass
	

func has_item(type):
	for i in items:
		if i.type == type:
			return true
	return false
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
	

func get_main_weapon_alien_damage():
	if items.size() == 0:
		return 1
	elif items.size() == 1:
		return items[0].weapon_power
	elif items.size() > 1:
		if items[0].weapon_power > items[1].weapon_power:
			return items[0].weapon_power
		else:
			return items[1].weapon_power
	pass

func get_main_weapon_location_damage():
	if items.size() == 0:
		return 0
	elif items.size() == 1:
		return items[0].weapon_power
	elif items.size() > 1:
		if items[0].weapon_power > items[1].weapon_power:
			return items[0].weapon_power
		else:
			return items[1].weapon_power
	pass
