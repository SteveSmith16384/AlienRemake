#class_name Main
extends Node2D

var locations = {}
var crew = {}

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
#	update_ui()
	pass


func _process(delta):
	for c in crew.values():
		c._process(delta)
	pass
	
	
func crew_selected(crewman_id):
	if selected_crewman != null and selected_crewman.id == crewman_id:
		return
		
	selected_crewman = crew[crewman_id]
	update_ui()
	pass


func update_ui():
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
	var location : Location = locations[loc_id]
	if menu_mode == Globals.MenuMode.GO_TO:
		# todo - check it is adjacent
		if selected_crewman.set_dest(location):
			$Log.text += selected_crewman.crew_name + " is now going to " + location.loc_name + "\n"
		else:
			$Log.text += "They are already going to " + selected_crewman.destination.loc_name + "\n"
		pass
	else:
		$Log.text += "That is the " + location.loc_name + "\n"
		if location.crew.size() > 0:
			$Log.text += "The following are here:\n"
			for c in location.crew:
				$Log.text += c.crew_name + ", "
			$Log.text += "\n"
		
	menu_mode = Globals.MenuMode.NONE
	pass
	

func cancel_selection():
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	
	
func crewman_moved(crewman, prev_loc):
	prev_loc.update_crewman_sprite()
	$Log.text += crewman.crew_name + " has arrived in the " + crewman.location.loc_name + "\n"
	crewman.location.update_crewman_sprite()
	pass
	
	
func load_data():
	# Locations
#	locations[Globals.Location.COMMAND_CENTER] = Location.new(Globals.Location.COMMAND_CENTER, "Command Centre")
#	locations[Globals.Location.COMMAND_CENTER] = Location.new(Globals.Location.COMMAND_CENTER, "Command Centre")

	var command_centre = Location.new(Globals.Location.COMMAND_CENTER, "Command Centre")
	locations[Globals.Location.COMMAND_CENTER] = command_centre
	var corridor1 = Location.new(Globals.Location.CORRIDOR1, "Corridor 1")
	locations[Globals.Location.CORRIDOR1] = corridor1
	var informary = Location.new(Globals.Location.INFIRMARY, "Infirmary")
	locations[Globals.Location.INFIRMARY] = informary
	var laboratory = Location.new(Globals.Location.LABORATORY, "Laboratory")
	locations[Globals.Location.LABORATORY] = laboratory
	
	set_adjacent(command_centre, corridor1)
	set_adjacent(informary, corridor1)
	set_adjacent(laboratory, corridor1)
	
	# Crew
	crew[Globals.Crew.DALLAS] = Crewman.new(self, Globals.Crew.DALLAS, "Dallas", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.KANE] = Crewman.new(self, Globals.Crew.KANE, "Kane", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.RIPLEY] = Crewman.new(self, Globals.Crew.RIPLEY, "Ripley", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.ASH] = Crewman.new(self, Globals.Crew.ASH, "Ash", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.LAMBERT] = Crewman.new(self, Globals.Crew.LAMBERT, "Lambert", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.PARKER] = Crewman.new(self, Globals.Crew.PARKER, "Parker", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.BRETT] = Crewman.new(self, Globals.Crew.BRETT, "Brett", Globals.Location.COMMAND_CENTER)
	
	# Items
	Item.new(self, Globals.ItemType.FLAMETHROWER, "Flamethrower", Globals.Location.COMMAND_CENTER)
	
	pass
	
func set_adjacent(loc1:Location, loc2:Location):
	loc1.adjacent.push_back(loc2)
	loc2.adjacent.push_back(loc1)
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
	
