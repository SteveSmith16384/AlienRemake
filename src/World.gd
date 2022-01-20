#class_name Main
extends Node2D

var locations = {}
#var items = {}
var crew = {}

var selected_crewman #_id : int
var menu_mode : int = Globals.MenuMode.NONE

func _ready():
	load_data()
	
	selected_crewman = crew[0]
	update_ui()
	pass


func _process(delta):
	for c in crew.values():
		c._process(delta)
	pass
	
	
func crew_selected(crewman_id):
	if selected_crewman.id == crewman_id:
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

	$CommandOptions.update_menu(location)
	pass
	

func set_menu_mode(mode):
	menu_mode = mode
	if menu_mode == Globals.MenuMode.GO_TO:
		$Log.text += "Select destination\n"
	pass
	
	
func location_selected(loc_id):
	var location = locations[loc_id]
	if menu_mode == Globals.MenuMode.GO_TO:
		if selected_crewman.set_dest(location):
			$Log.text = selected_crewman.crew_name + " is now going to " + location.loc_name + "\n"
		else:
			$Log.text += "They are already going to " + selected_crewman.destination.loc_name + "\n"
		pass
	pass
	

func crewman_arrived(var crewman):
	$Log.text += crewman.crew_name + " has arrived in the " + crewman.location.loc_name + "\n"
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
	
	# Crew
	crew[Globals.Crew.DALLAS] = Crewman.new(self, Globals.Crew.DALLAS, "Dallas", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.KANE] = Crewman.new(self, Globals.Crew.KANE, "Kane", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.RIPLEY] = Crewman.new(self, Globals.Crew.RIPLEY, "Ripley", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.ASH] = Crewman.new(self, Globals.Crew.ASH, "Ash", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.LAMBERT] = Crewman.new(self, Globals.Crew.LAMBERT, "Lambert", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.PARKER] = Crewman.new(self, Globals.Crew.PARKER, "Parker", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.BRETT] = Crewman.new(self, Globals.Crew.BRETT, "Brett", Globals.Location.COMMAND_CENTER)
	
	# Items
	var flamethrower = Item.new(self, Globals.ItemType.FLAMETHROWER, "Flamethrower", Globals.Location.COMMAND_CENTER)
	
	pass
	
	
func log(s):
	$Log.text += s + "\n"
	pass
	
