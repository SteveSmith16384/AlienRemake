#class_name Main
extends Node2D

var locations = {}
var crew = {}

var time_left : float = 60 * 60
var selected_crewman : Crewman
var menu_mode : int = Globals.MenuMode.NONE

func _ready():
	load_data()
	$LocationSelector.visible = false
	$ItemSelector.visible = false
	
	yield(get_tree().create_timer(2), "timeout") # Wait to allow the areas ot be populated

	for l in locations.values():
		l.update_crewman_sprite()
		
	crew_selected(crew[0].id)
	$CharacterSelector.update_statuses()
#	update_ui()
	pass


func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		#$AudioStreamPlayer_Keypress.play()
		OS.window_fullscreen = !OS.window_fullscreen

	time_left -= delta # todo - check when run out
	$LabelTimeLeft.text = "Time: " + str(int(time_left))
	for c in crew.values():
		c._process(delta)
	pass
	
	
func crew_selected(crewman_id):
	if selected_crewman != null and selected_crewman.id == crewman_id:
		return
		
	selected_crewman = crew[crewman_id]
	update_ui()
	pass


func update_ui(): # todo - rename
	$Log.text = ""
	
#	var crewman = crew[selected_crewman_id];
	$Log.text += selected_crewman.crew_name + " selected.\n"
	
	var location = selected_crewman.location
	$Log.text += "They are in the " + location.loc_name + "\n"
	
	var dest = selected_crewman.destination
	if dest != null:
		append_log("They going to the " + dest.loc_name)
	
	if selected_crewman.items.size() > 0:
		append_log("They are carrying:")
		for i in selected_crewman.items:
			$Log.text += i.item_name + ","
	$CommandOptions.update_menu(location)
	
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	

func set_menu_mode(mode):
	menu_mode = mode
	if menu_mode == Globals.MenuMode.GO_TO:
		$Log.text += "Select Destination\n"
		$CommandOptions.visible = false
		$LocationSelector.update_list(selected_crewman.location)
		$LocationSelector.visible = true
		$ItemSelector.visible = false
	elif menu_mode == Globals.MenuMode.PICK_UP:
		$Log.text += "Select Item\n"
		$CommandOptions.visible = false
		$ItemSelector.update_list(selected_crewman.location)
		$ItemSelector.visible = true
	else:
		$CommandOptions.visible = true
		$LocationSelector.visible = false
		$ItemSelector.visible = false
	pass
	
	
func location_selected(loc_id):
	$Log.text = ""
	var selected_location : Location = locations[loc_id]
	if menu_mode == Globals.MenuMode.GO_TO:
		if is_location_adjacent(selected_location, selected_crewman.location) == false:
			append_log("That location is not adjacent")
			return
		if selected_crewman.set_dest(selected_location):
			$CharacterSelector.update_statuses()
			$Log.text += selected_crewman.crew_name + " is now going to " + selected_location.loc_name + "\n"
		else:
			$Log.text += "They are already going to " + selected_crewman.destination.loc_name + "\n"
		pass
	else:
		$Log.text += "That is the " + selected_location.loc_name + "\n"
		if selected_location.crew.size() > 0:
			$Log.text += "The following are here:\n"
			for c in selected_location.crew:
				$Log.text += c.crew_name + ", "
			$Log.text += "\n"
		else:
			append_log("There is no-one here")
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	

func is_location_adjacent(loc1: Location, loc2: Location):
	return loc1.adjacent.has(loc2)
	
	
func cancel_selection():
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	
	
func crewman_moved(crewman, prev_loc):
	prev_loc.update_crewman_sprite()
	$Log.text += crewman.crew_name + " has arrived in the " + crewman.location.loc_name + "\n"
	crewman.location.update_crewman_sprite()
	$CharacterSelector.update_statuses()
	pass
	
	
func load_data():
	# Middle deck
	locations[Globals.Location.COMMAND_CENTER] = Location.new(Globals.Location.COMMAND_CENTER, "Command Centre")
	locations[Globals.Location.INFIRMARY] = Location.new(Globals.Location.INFIRMARY, "Infirmary")
	locations[Globals.Location.CORRIDOR_1] = Location.new(Globals.Location.CORRIDOR_1, "Corridor 1")
	locations[Globals.Location.LABORATORY] = Location.new(Globals.Location.LABORATORY, "Laboratory")
	locations[Globals.Location.CORRIDOR_2] = Location.new(Globals.Location.CORRIDOR_2, "Corridor 2")
	locations[Globals.Location.INF_STORES] = Location.new(Globals.Location.INF_STORES, "Inf Stores")
	locations[Globals.Location.CRYO_VAULT] = Location.new(Globals.Location.CRYO_VAULT, "Cryo Vault")
	locations[Globals.Location.LAB_STORES] = Location.new(Globals.Location.LAB_STORES, "Lab Stores")
	locations[Globals.Location.ARMOURY] = Location.new(Globals.Location.ARMOURY, "Armoury")
	locations[Globals.Location.CORRIDOR_3] = Location.new(Globals.Location.CORRIDOR_3, "Corridor 3")
	locations[Globals.Location.CORRIDOR_4] = Location.new(Globals.Location.CORRIDOR_4, "Corridor 4")
	locations[Globals.Location.CORRIDOR_5] = Location.new(Globals.Location.CORRIDOR_5, "Corridor 5")
	locations[Globals.Location.STORES_1] = Location.new(Globals.Location.STORES_1, "Stores 1")
	locations[Globals.Location.ENGINE_1] = Location.new(Globals.Location.ENGINE_1, "Engine 1")
	locations[Globals.Location.ENGINE_2] = Location.new(Globals.Location.ENGINE_2, "Engine 2")
	locations[Globals.Location.ENGINE_3] = Location.new(Globals.Location.ENGINE_3, "Engine 3")
	
	set_adjacent(Globals.Location.COMMAND_CENTER, Globals.Location.CORRIDOR_1)
	set_adjacent(Globals.Location.INFIRMARY, Globals.Location.CORRIDOR_1)
	set_adjacent(Globals.Location.LABORATORY, Globals.Location.CORRIDOR_1)
	set_adjacent(Globals.Location.CORRIDOR_1, Globals.Location.CORRIDOR_2)
	set_adjacent(Globals.Location.CORRIDOR_2, Globals.Location.CORRIDOR_3)
	set_adjacent(Globals.Location.CORRIDOR_2, Globals.Location.CRYO_VAULT)
	set_adjacent(Globals.Location.CORRIDOR_2, Globals.Location.CORRIDOR_5)
	set_adjacent(Globals.Location.CORRIDOR_3, Globals.Location.INF_STORES)
	set_adjacent(Globals.Location.CORRIDOR_3, Globals.Location.ARMOURY)
	set_adjacent(Globals.Location.CORRIDOR_3, Globals.Location.CORRIDOR_4)
	set_adjacent(Globals.Location.CORRIDOR_3, Globals.Location.ENGINE_1)
	set_adjacent(Globals.Location.CORRIDOR_4, Globals.Location.CORRIDOR_5)
	set_adjacent(Globals.Location.CORRIDOR_4, Globals.Location.ENGINE_2)
	set_adjacent(Globals.Location.CORRIDOR_5, Globals.Location.LAB_STORES)
	set_adjacent(Globals.Location.CORRIDOR_5, Globals.Location.STORES_1)
	set_adjacent(Globals.Location.CORRIDOR_5, Globals.Location.ENGINE_3)
	
	# Crew
	crew[Globals.Crew.DALLAS] = Crewman.new(self, Globals.Crew.DALLAS, "Dallas", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.KANE] = Crewman.new(self, Globals.Crew.KANE, "Kane", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.RIPLEY] = Crewman.new(self, Globals.Crew.RIPLEY, "Ripley", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.ASH] = Crewman.new(self, Globals.Crew.ASH, "Ash", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.LAMBERT] = Crewman.new(self, Globals.Crew.LAMBERT, "Lambert", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.PARKER] = Crewman.new(self, Globals.Crew.PARKER, "Parker", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.BRETT] = Crewman.new(self, Globals.Crew.BRETT, "Brett", Globals.Location.COMMAND_CENTER)
	var android_crew_id = Globals.rnd.randi_range(0, crew.size()-1)
	crew[android_crew_id].is_android = true
	
	# Items - todo - place randomly
	Item.new(self, Globals.ItemType.FLAMETHROWER, "Flamethrower", get_random_location())
	
	pass
	
	
func get_random_location():
	var loc_id = Globals.rnd.randi_range(0, locations.size()-1)
	return loc_id
	
	
func set_adjacent(loc1:int, loc2:int):
	locations[loc1].adjacent.push_back(locations[loc2])
	locations[loc2].adjacent.push_back(locations[loc1])
	pass
	
	
func append_log(s):
	$Log.text += s + "\n"
	pass
	

func item_selected(type):
	var location : Location = selected_crewman.location#locations[selected_crewman.location]
	var item = location.get_item(type)
	if item != null:
		location.remove_item(type)
		selected_crewman.items.push_back(item)
		append_log(item.item_name + " picked up")
	pass
	
