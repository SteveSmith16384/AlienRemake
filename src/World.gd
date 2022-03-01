#class_name Main
extends Node2D

var locations = {}
var crew = {}
var alien: Alien
var jones: Jones

var time_left : float = Globals.START_TIME
var selected_crewman : Crewman
var menu_mode : int = Globals.MenuMode.NONE
var refresh_ui: bool = true

func _ready():
	load_data()
	$LocationSelector.visible = false
	$ItemSelector.visible = false
	
	yield(get_tree().create_timer(2), "timeout") # Wait to allow the areas ot be populated

#	for l in locations.values():
#		l.update_crewman_sprite()
		
	crew_selected(crew[0].id)
	#$CharacterSelector.update_statuses()
	refresh_ui = true
	pass


func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		#$AudioStreamPlayer_Keypress.play()
		OS.window_fullscreen = !OS.window_fullscreen

	time_left -= delta # todo - check when run out
	$LabelTimeLeft.text = "TOOH: " + str(int(time_left))
	
	if alien == null and time_left < Globals.START_TIME-5:
		var alien_crew_id = Globals.rnd.randi_range(0, crew.size()-1)
		crewman_died(crew[alien_crew_id])
		append_log("AN ALIEN has burst from the chest of " + crew[alien_crew_id].crew_name)
		alien = Alien.new(self, crew[alien_crew_id].location)
		alien_moved(alien.location)
	
	for c in crew.values():
		c._process(delta)
	if alien != null:
		alien._process(delta)
	jones._process(delta)
	
	if refresh_ui:
		update_ui()
		refresh_ui = false
	pass
	
	
func update_ui():
	$CharacterSelector.update_statuses()
	for l in locations.values():
		l.update_crewman_sprite()
		if alien != null:
			l.update_alien_sprite(alien.location == l)
			
	$AlertLog.clear_log()
#	$AlertLog.add("Test")
	pass
	
	
func crew_selected(crewman_id):
	if selected_crewman != null and selected_crewman.id == crewman_id:
		return
		
	selected_crewman = crew[crewman_id]
	
	append_log("")
	append_log(selected_crewman.crew_name + " selected")
	
	var location = selected_crewman.location
	append_log("They are in the " + location.loc_name)
	
	var dest = selected_crewman.destination
	if dest != null:
		append_log("They going to the " + dest.loc_name)
	
	if selected_crewman.items.size() > 0:
		append_log("They are carrying:")
		for i in selected_crewman.items:
			append_log(i.item_name)
		append_log("")

	if location.items.size() > 0:
		append_log("The following items are here:")
		for i in location.items:
			append_log(i.item_name)
		append_log("")

#	$CommandOptions.update_menu(location, selected_crewman)
	refresh_ui = true
	
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	

func set_menu_mode(mode):
	menu_mode = mode
	if menu_mode == Globals.MenuMode.GO_TO:
		append_log("Select Destination")
		$CommandOptions.visible = false
		$LocationSelector.update_list(selected_crewman.location)
		$LocationSelector.visible = true
		$ItemSelector.visible = false
	elif menu_mode == Globals.MenuMode.PICK_UP:
		append_log("Select Item to Pick up")
		$CommandOptions.visible = false
		$ItemSelector.update_list(selected_crewman.location.items)
		$ItemSelector.visible = true
	elif menu_mode == Globals.MenuMode.DROP:
		append_log("Select Item to Drop")
		$CommandOptions.visible = false
		$ItemSelector.update_list(selected_crewman.items)
		$ItemSelector.visible = true
	elif menu_mode == Globals.MenuMode.USE:
		append_log("Select Item to use")
		$CommandOptions.visible = false
		$ItemSelector.update_list(selected_crewman.items)
		$ItemSelector.visible = true
	elif menu_mode == Globals.MenuMode.SPECIAL:
		# todo
		pass
	elif menu_mode == Globals.MenuMode.NONE:
		$CommandOptions.update_menu(selected_crewman.location, selected_crewman)
	
		$CommandOptions.visible = true
		$LocationSelector.visible = false
		$ItemSelector.visible = false
	else:
		if Globals.RELEASE_MODE == false:
			push_error("Unknown menu mode: " + str(mode))
		$CommandOptions.visible = true
		$LocationSelector.visible = false
		$ItemSelector.visible = false
	pass
	
	
func location_selected(loc_id, move_to: bool = false):
	var selected_location : Location = locations[loc_id]
	if menu_mode == Globals.MenuMode.GO_TO or move_to:
		if is_location_adjacent(selected_location, selected_crewman.location) == false:
			append_log("That location is not adjacent")
			return
		if selected_crewman.set_dest(selected_location):
			$AudioStreamPlayer_CommandGiven.play()
			#$CharacterSelector.update_statuses()
			append_log(selected_crewman.crew_name + " is now going to " + selected_location.loc_name)
		else:
			append_log("They are already going to " + selected_crewman.destination.loc_name)
		pass
	else:
		append_log("That is the " + selected_location.loc_name)
		if selected_location.crew.size() > 0:
			append_log("The following are here:")
			for c in selected_location.crew:
				append_log(c.crew_name)
		else:
			append_log("There is no-one here")
			
	refresh_ui = true
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	

func is_location_adjacent(loc1: Location, loc2: Location):
	return loc1.adjacent.has(loc2)
	
	
func cancel_selection():
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	
	
func crewman_moved(crewman, prev_loc):
	$AudioStreamPlayer_CrewmanArrived.play()
	#prev_loc.update_crewman_sprite()
	append_log(crewman.crew_name + " has arrived in the " + crewman.location.loc_name)
	#crewman.location.update_crewman_sprite()
	#$CharacterSelector.update_statuses()
	refresh_ui = true
	pass
	

func alien_moved(prev_loc: Location):
	$AudioStreamPlayer_CrewmanArrived.play()
	#prev_loc.update_alien_sprite(false)
	#$Log.text += "Alien has arrived in the " + alien.location.loc_name + "\n"
	#alien.location.update_alien_sprite(true)
	refresh_ui = true
	pass
	
	
func jones_moved():
	if jones.location.crew.size() > 0:
		var crew = jones.location.crew[0]
		append_log(crew.crew_name + " has seen Jones in the " + jones.location.loc_name)
		$AudioStreamPlayer_JonesSeen.play()
		refresh_ui = true
	pass
	
	
func load_data():
	# Upper Deck
	locations[Globals.Location.LIVING_QUARTERS] = Location.new(Globals.Location.LIVING_QUARTERS, "Living Quarters")
	locations[Globals.Location.AIRLOCK_1] = Location.new(Globals.Location.AIRLOCK_1, "Airlock 1")
	locations[Globals.Location.STORES_2] = Location.new(Globals.Location.STORES_2, "Stores 2")
	locations[Globals.Location.MESS] = Location.new(Globals.Location.MESS, "Mess")
	locations[Globals.Location.CORRIDOR_6] = Location.new(Globals.Location.CORRIDOR_6, "Corridor 6")
	locations[Globals.Location.COMPUTER] = Location.new(Globals.Location.COMPUTER, "Computer")
	locations[Globals.Location.RECREATION_AREA] = Location.new(Globals.Location.RECREATION_AREA, "Recreation Area")
	locations[Globals.Location.AIRLOCK_2] = Location.new(Globals.Location.AIRLOCK_2, "Airlock 2")
	locations[Globals.Location.STORES_3] = Location.new(Globals.Location.STORES_3, "Stores 3")

	# Upper deck adjacent
	set_adjacent(Globals.Location.LIVING_QUARTERS, Globals.Location.MESS)
	set_adjacent(Globals.Location.AIRLOCK_1, Globals.Location.CORRIDOR_6)
	set_adjacent(Globals.Location.STORES_2, Globals.Location.COMPUTER)
	set_adjacent(Globals.Location.MESS, Globals.Location.CORRIDOR_6)
	set_adjacent(Globals.Location.CORRIDOR_6, Globals.Location.COMPUTER)
	set_adjacent(Globals.Location.RECREATION_AREA, Globals.Location.MESS)
	set_adjacent(Globals.Location.AIRLOCK_2, Globals.Location.CORRIDOR_6)
	set_adjacent(Globals.Location.STORES_3, Globals.Location.CORRIDOR_6)
	
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
	
	# Middle deck adjacent
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
	
	
	# Lower Deck
	locations[Globals.Location.SHUTTLE_STORE] = Location.new(Globals.Location.SHUTTLE_STORE, "Shuttle Store")
	locations[Globals.Location.CARGO_POD_1] = Location.new(Globals.Location.CARGO_POD_1, "Cargo Pod 1")
	locations[Globals.Location.SHUTTLE_BAY] = Location.new(Globals.Location.SHUTTLE_BAY, "Shuttle Bay")
	locations[Globals.Location.CARGO_POD_2] = Location.new(Globals.Location.CARGO_POD_2, "Cargo Pod 2")
	locations[Globals.Location.CORRIDOR_7] = Location.new(Globals.Location.CORRIDOR_7, "Corridor 7")
	locations[Globals.Location.LIFE_SUPPORT] = Location.new(Globals.Location.LIFE_SUPPORT, "Life Support")
	locations[Globals.Location.ENGINEERING] = Location.new(Globals.Location.ENGINEERING, "Engineering")
	locations[Globals.Location.ENG_STORES] = Location.new(Globals.Location.ENG_STORES, "Eng Stores")
	locations[Globals.Location.CARGO_POD_3] = Location.new(Globals.Location.CARGO_POD_3, "Cargo Pod 3")
	
	# Lower deck adjacent
	set_adjacent(Globals.Location.SHUTTLE_STORE, Globals.Location.SHUTTLE_BAY)
	set_adjacent(Globals.Location.CARGO_POD_1, Globals.Location.CARGO_POD_2)
	set_adjacent(Globals.Location.SHUTTLE_BAY, Globals.Location.CARGO_POD_2)
	set_adjacent(Globals.Location.CARGO_POD_2, Globals.Location.CORRIDOR_7)
	set_adjacent(Globals.Location.LIFE_SUPPORT, Globals.Location.CORRIDOR_7)
	set_adjacent(Globals.Location.SHUTTLE_BAY, Globals.Location.ENGINEERING)
	set_adjacent(Globals.Location.ENG_STORES, Globals.Location.ENGINEERING)
	set_adjacent(Globals.Location.CARGO_POD_2, Globals.Location.CARGO_POD_3)

	# Crew
	crew[Globals.Crew.DALLAS] = Crewman.new(self, Globals.Crew.DALLAS, "Dallas", get_random_location_id())
	crew[Globals.Crew.KANE] = Crewman.new(self, Globals.Crew.KANE, "Kane", get_random_location_id())
	crew[Globals.Crew.RIPLEY] = Crewman.new(self, Globals.Crew.RIPLEY, "Ripley", get_random_location_id())
	crew[Globals.Crew.ASH] = Crewman.new(self, Globals.Crew.ASH, "Ash", get_random_location_id())
	crew[Globals.Crew.LAMBERT] = Crewman.new(self, Globals.Crew.LAMBERT, "Lambert", get_random_location_id())
	crew[Globals.Crew.PARKER] = Crewman.new(self, Globals.Crew.PARKER, "Parker", get_random_location_id())
	crew[Globals.Crew.BRETT] = Crewman.new(self, Globals.Crew.BRETT, "Brett", get_random_location_id())
	
	# Choose Android
	var android_crew_id = Globals.rnd.randi_range(0, crew.size()-1)
	crew[android_crew_id].is_android = true
	#print(crew[android_crew_id].crew_name + " is an Android!")
	
	# Items
	for _i in range(3):
		var _unused = Item.new(self, Globals.ItemType.INCINERATOR, "Incinerator", get_random_location_id())
	for _i in range(3):
		var _unused = Item.new(self, Globals.ItemType.LASER, "LASER", get_random_location_id())
	for _i in range(3):
		var _unused = Item.new(self, Globals.ItemType.ELECTRIC_PROD, "Electric Prod", get_random_location_id())
	for _i in range(1):
		var _unused = Item.new(self, Globals.ItemType.NET, "Net", get_random_location_id())
	for _i in range(2):
		var _unused = Item.new(self, Globals.ItemType.SPANNER, "Spanner", get_random_location_id())
	for _i in range(1):
		var _unused = Item.new(self, Globals.ItemType.HARPOON, "Harpoon", get_random_location_id())
	for _i in range(4):
		var _unused = Item.new(self, Globals.ItemType.FIRE_EXT, "Fire Ext.", get_random_location_id())
	for _i in range(2):
		var _unused = Item.new(self, Globals.ItemType.TRACKER, "Tracker", get_random_location_id())
	for _i in range(1):
		var _unused = Item.new(self, Globals.ItemType.CAT_BOX, "Cat Box", get_random_location_id())
	
	jones = Jones.new(self, locations[get_random_location_id()])
	jones_moved()
	pass
	
	
func get_random_location_id():
	var loc_id = Globals.rnd.randi_range(0, locations.size()-1)
	return loc_id
	
	
func set_adjacent(loc1:int, loc2:int):
	locations[loc1].adjacent.push_back(locations[loc2])
	locations[loc2].adjacent.push_back(locations[loc1])
	pass
	
	
func append_log(s, clear:bool = false):
	$Log.add(s, clear)
	pass
	

func item_selected(type):
	if menu_mode == Globals.MenuMode.PICK_UP:
		var location : Location = selected_crewman.location#locations[selected_crewman.location]
		var item = find_item_by_type(location.items, type)
		if item != null:
			location.items.erase(item)
			selected_crewman.items.push_back(item)
			append_log(item.item_name + " picked up")
			set_menu_mode(Globals.MenuMode.NONE)
			$AudioStreamPlayer_CommandGiven.play()
	elif menu_mode == Globals.MenuMode.DROP:
		var item = find_item_by_type(selected_crewman.items, type)
		if item != null:
			var location : Location = selected_crewman.location#locations[selected_crewman.location]
			location.items.push_back(item)
			selected_crewman.items.erase(item)
			append_log(item.item_name + " dropped")
			set_menu_mode(Globals.MenuMode.NONE)
			$AudioStreamPlayer_CommandGiven.play()
	elif menu_mode == Globals.MenuMode.USE:
		var item = find_item_by_type(selected_crewman.items, type)
		if item != null:
			if item.type == Globals.ItemType.NET and selected_crewman.location.has(jones):
				jones.is_in_net = true
				append_log(selected_crewman.name + " has caught Jones in the net")
				item.name = "Net with Jones"
				$AudioStreamPlayer_JonesCaught.play()
				refresh_ui = true
	else:
		push_error("Unknown menu mode: " + str(menu_mode))
	pass
	

func find_item_by_type(items, type):
	for item in items:
		if item.type == type:
			return item
	
	return null
	

func _on_SfxTimer_timeout():
	# Check for tracker
	if alien == null:
		return
		
	for c in crew.values():
		if find_item_by_type(c.items, Globals.ItemType.TRACKER) != null:
			if alien.location == c.location or is_location_adjacent(alien.location, c.location):
				$AudioStreamPlayer_Tracker.play()
				return
			if jones.location == c.location or is_location_adjacent(jones.location, c.location):
				$AudioStreamPlayer_Tracker.play()
				return
		pass
	pass


func crewman_wounded(crewman : Crewman, amt:int):
	crewman.health -= amt
	if crewman.health <= 0:
		crewman_died(crewman)
	pass


func crewman_died(crewman : Crewman):
	$AudioStreamPlayer_CrewDied.play()
	$AudioStreamPlayer_Static.play()
	var _unused = Item.new(self, Globals.ItemType.CORPSE, "Body of " + crewman.crew_name, crewman.location.id)
	crewman.died()
	refresh_ui = true
	pass


func combat(location : Location):
	var all_crew = location.crew
	var alien_attacks_crew = all_crew[Globals.rnd.randi_range(0, all_crew.size()-1)]
	
	append_log("The Alien attacks " + alien_attacks_crew.crew_name)
	crewman_wounded(alien_attacks_crew, Globals.rnd.randi_range(10, 40))

	for c in location.crew:
		# todo - choose weapon, sfx
		alien.health -= Globals.rnd.randi_range(5, 10)
		append_log(c.crew_name + " attacks the Alien")
		if alien.health <= 0:
			append_log("The Alien has been killed")
			$AudioStreamPlayer_AlienDeath.play()
			alien = null
			#alien.queue_free()
			return
		pass
		
	pass
	
	
func _on_SelectUpperDeck_pressed():
	$DeckNode/UpperDeck.visible = true
	$DeckNode/MiddleDeck.visible = false
	$DeckNode/LowerDeck.visible = false
	pass


func _on_SelectMiddleDeck_pressed():
	$DeckNode/UpperDeck.visible = false
	$DeckNode/MiddleDeck.visible = true
	$DeckNode/LowerDeck.visible = false
	pass


func _on_SelectLowerDeck_pressed():
	$DeckNode/UpperDeck.visible = false
	$DeckNode/MiddleDeck.visible = false
	$DeckNode/LowerDeck.visible = true
	pass
