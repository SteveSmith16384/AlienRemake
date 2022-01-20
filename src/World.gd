#class_name Main
extends Node2D

var locations = {}
#var items = {}
var crew = {}

var selected_crewman_id : int

func _ready():
	load_data()
	
	selected_crewman_id = 0
	update_ui()
	pass


func _on_CharacterSelector_CrewSelected(crewman_id):
	if selected_crewman_id == crewman_id:
		return
		
	selected_crewman_id = crewman_id
	update_ui()
	pass


func update_ui():
	$Log.text = ""
	
	var crewman = crew[selected_crewman_id];
	$Log.text += crewman.crew_name + " selected."
	
	var location = locations[crewman.location_id]
	$CommandOptions.update_menu(location)
	pass
	
	
func load_data():
	# Locations
	var command_centre = Location.new(Globals.Location.COMMAND_CENTER, "Command Centre")
	locations[Globals.Location.COMMAND_CENTER] = command_centre
	
	# Crew
	var dallas = Crewman.new(self, Globals.Crew.DALLAS, "Dallas", Globals.Location.COMMAND_CENTER)
	crew[Globals.Crew.DALLAS] = dallas
#	command_centre.crew.push_back(dallas)
	
	# Items
	var flamethrower = Item.new(self, Globals.ItemType.FLAMETHROWER, "Flamethrower", Globals.Location.COMMAND_CENTER)
#	command_centre.items.push_back(flamethrower)
	
	pass
	
	
