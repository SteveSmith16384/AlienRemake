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
	if is_in_game() == false:
		return
		
	if adjusted_morale < 10:
		return
	
	if location.id == Globals.Location.INFIRMARY:
		if health > 50 and health < 100:
			if location.activated == false:
				main.activate_location(location)
			health += delta/2
			if health >= 100:
				health = 100
				location.activated = false
			
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
	

func _get_main_weapon():
	if items.size() == 0:
		return null
	elif items.size() == 1:
		return items[0]
	elif items.size() > 1:
		if items[0].alien_damage > items[1].alien_damage:
			return items[0]
		else:
			return items[1]
	pass
	
	
func get_main_weapon_alien_damage():
	var wep = _get_main_weapon()
	if wep == null:
		return 1
	else:
		return wep.alien_damage
	pass


func get_main_weapon_location_damage():
	var wep = _get_main_weapon()
	if wep == null:
		return 1
	else:
		return wep.location_damage
	pass


func get_main_weapon_type():
	var wep = _get_main_weapon()
	if wep == null:
		return -1
	else:
		return wep.type
	pass


func is_in_game():
	return in_cryo == false and health > 0


func get_health_string() -> String:
	if health > 90:
		return "ok"
	elif health > 50:
		return "wounded"
	elif health > 0:
		return "collapsed"
	else:
		return "dead"
	pass
	
	
