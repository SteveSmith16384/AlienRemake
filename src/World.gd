#class_name Main
extends Node2D

var locations = {}
var crew = {}
var alien#: Alien
var jones: Jones

var oxygen : float = Globals.OXYGEN
var selected_crewman : Crewman
var menu_mode : int = Globals.MenuMode.NONE
var refresh_ui: bool = true
var alien_crew_id : int
var alien_created = false
var self_destruct_time_left : float
var airlock1_open = false
var airlock2_open = false

var android_activated = false
#var android_revealed = false

func _ready():
	load_data()
	$Menus/LocationSelector.visible = false
	$Menus/ItemSelector.visible = false
	$Menus/SpecialSelector.visible = false
	$LabelSelfDestructTimeLeft.visible = false
	
	yield(get_tree().create_timer(2), "timeout") # Wait to allow the areas ot be populated

	refresh_ui = true
	
	$Audio/ConsoleBeep.play()
	pass


func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		$Audio/AudioStreamPlayer_Click.play()
		OS.window_fullscreen = !OS.window_fullscreen

	$LabelTimeLeft.text = "TOOH: " + str(int(oxygen))
	
	if Globals.self_destruct_activated:
		if self_destruct_time_left > 0:
			self_destruct_time_left -= delta
			$LabelSelfDestructTimeLeft.text = "SELF DESTRUCT: " + str(int(self_destruct_time_left))
			if self_destruct_time_left <= 0:
				ship_exploded()
				return
			
	if alien_created == false and oxygen < Globals.OXYGEN-15:
		alien_created = true
		crewman_died(crew[alien_crew_id])
		$Audio/AudioStreamPlayer_AlienBorn.play()
		append_log("An ALIEN has burst from the chest of " + crew[alien_crew_id].crew_name, Color.red)
		alien = Alien.new(self, crew[alien_crew_id].location)
		alien_moved()
	
	for l in locations.values():
		l._process(delta)
	for c in crew.values():
		c._process(delta)
	if alien != null:
		alien._process(delta)
	jones._process(delta)
	
	var life_support = locations[Globals.Location.LIFE_SUPPORT]
	if life_support.damage > 50:
		oxygen -= delta

	if refresh_ui:
		update_ui()
		refresh_ui = false
	pass
	
	
func update_ui():
	$CharacterSelector.update_statuses()
	for l in locations.values():
		l.update_sprites()
			
	$AlertLog.clear_log()
	if android_activated and Globals.android.health > 0:
		$AlertLog.add(Globals.android.crew_name + " is an Android", Color.red)
	for l in locations.values():
		if l.fire:
			$AlertLog.add("Fire in " + l.loc_name + ".  Damage:" + l.damage, Color.red)
	for c in crew.values():
		if c.fighting_fire:
			$AlertLog.add(c.crew_name + " is fighting a fire", Color.red)
	
	if oxygen <= 0:
		$AlertLog.add("Oxygen expired", Color.red)
	if jones.can_sense_alien:
		$AlertLog.add("Jones looks uneasy", Color.red)
	pass
	
	
func crew_selected(crewman_id):
	selected_crewman = crew[crewman_id]
	
	append_log("----")
	append_log(selected_crewman.crew_name + " selected")
	append_log("They are " + selected_crewman.get_health_string())
	
	var location = selected_crewman.location
	append_log("They are in " + location.loc_name + ".  Damage: " + str(int(location.damage)) + "%")
	
	var dest = selected_crewman.destination
	if dest != null:
		append_log("They going to the " + dest.loc_name)
	
	if selected_crewman.items.size() > 0:
		var s = "They are carrying: "
		for i in selected_crewman.items:
			s += i.item_name + ", "
		append_log(s)

	if location.items.size() > 0:
		var s = "Also here: "
		for i in location.items:
			s += i.item_name + ", "
		append_log(s)

	$DeckNode/LowerDeck.visible = false
	$DeckNode/MiddleDeck.visible = false
	$DeckNode/UpperDeck.visible = false
	location.area.get_parent().visible = true
	
	refresh_ui = true
	
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	

func set_menu_mode(mode):
	$Menus/CommandOptions.visible = false
	$Menus/ItemSelector.visible = false
	$Menus/SpecialSelector.visible = false
	$Menus/LocationSelector.visible = false

	if selected_crewman == null:
		return

	menu_mode = mode
	if menu_mode == Globals.MenuMode.GO_TO:
		append_log("Select Destination")
		$Menus/LocationSelector.update_list(selected_crewman.location)
		$Menus/LocationSelector.visible = true
	elif menu_mode == Globals.MenuMode.PICK_UP:
		append_log("Select Item to Pick up")
		$Menus/ItemSelector.update_list(selected_crewman.location.items)
		$Menus/ItemSelector.visible = true
	elif menu_mode == Globals.MenuMode.DROP:
		append_log("Select Item to Drop")
		$Menus/ItemSelector.update_list(selected_crewman.items)
		$Menus/ItemSelector.visible = true
	elif menu_mode == Globals.MenuMode.USE:
		append_log("Select Item to use")
		$Menus/ItemSelector.update_list(selected_crewman.items)
		$Menus/ItemSelector.visible = true
	elif menu_mode == Globals.MenuMode.SPECIAL:
		$Menus/SpecialSelector.visible = true
	elif menu_mode == Globals.MenuMode.NONE:
		var show_special = $Menus/SpecialSelector.update_list(selected_crewman.location)
		$Menus/CommandOptions.update_menu(selected_crewman.location, selected_crewman, show_special)
		$Menus/CommandOptions.visible = true
	else:
		if Globals.RELEASE_MODE == false:
			push_error("Unknown menu mode: " + str(mode))
		$Menus/CommandOptions.visible = true
	pass
	
	
func location_selected(loc_id, move_to: bool = false):
	var selected_location : Location = locations[loc_id]
	if selected_crewman != null and (menu_mode == Globals.MenuMode.GO_TO or move_to):
		if is_location_adjacent(selected_location, selected_crewman.location) == false:
			append_log("That location is not adjacent", Color.yellow)
			return
		elif loc_id == Globals.Location.AIRLOCK_1 and airlock1_open:
			append_log("Airlock 1 is open", Color.yellow)
			return
		elif loc_id == Globals.Location.AIRLOCK_2 and airlock2_open:
			append_log("Airlock 2 is open", Color.yellow)
			return
		if selected_crewman.set_dest(selected_location):
			$Audio/AudioStreamPlayer_CommandGiven.play()
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
	
	
func crewman_moved(crewman: Crewman):
	$Audio/AudioStreamPlayer_CrewmanArrived.play()
	if android_activated == false or crewman.is_android == false:
		append_log(crewman.crew_name + " has arrived in the " + crewman.location.loc_name)
	refresh_ui = true
	pass
	

func alien_moved():
	$Audio/AudioStreamPlayer_CrewmanArrived.play()
	refresh_ui = true
	pass
	
	
func jones_moved():
	if jones.location.crew.size() > 0:
		var crewman = jones.location.crew[0]
		append_log(crewman.crew_name + " has seen Jones in the " + jones.location.loc_name)
		$Audio/AudioStreamPlayer_JonesSeen.play()
		
		for c in jones.location.crew:
			try_and_catch_jones(c)
		refresh_ui = true
	pass
	
	
func load_data():
	# Upper Deck
	locations[Globals.Location.LIVING_QUARTERS] = Location.new(self, Globals.Location.LIVING_QUARTERS, "Living Quarters")
	locations[Globals.Location.AIRLOCK_1] = Location.new(self, Globals.Location.AIRLOCK_1, "Airlock 1")
	locations[Globals.Location.STORES_2] = Location.new(self, Globals.Location.STORES_2, "Stores 2")
	locations[Globals.Location.MESS] = Location.new(self, Globals.Location.MESS, "Mess")
	locations[Globals.Location.CORRIDOR_6] = Location.new(self, Globals.Location.CORRIDOR_6, "Corridor 6")
	locations[Globals.Location.COMPUTER] = Location.new(self, Globals.Location.COMPUTER, "Computer")
	locations[Globals.Location.RECREATION_AREA] = Location.new(self, Globals.Location.RECREATION_AREA, "Recreation Area")
	locations[Globals.Location.AIRLOCK_2] = Location.new(self, Globals.Location.AIRLOCK_2, "Airlock 2")
	locations[Globals.Location.STORES_3] = Location.new(self, Globals.Location.STORES_3, "Stores 3")

	# Upper deck adjacent
	set_adjacent(Globals.Location.LIVING_QUARTERS, Globals.Location.MESS)
	set_adjacent(Globals.Location.LIVING_QUARTERS, Globals.Location.RECREATION_AREA)
	set_adjacent(Globals.Location.AIRLOCK_1, Globals.Location.CORRIDOR_6)
	set_adjacent(Globals.Location.STORES_2, Globals.Location.COMPUTER)
	set_adjacent(Globals.Location.MESS, Globals.Location.CORRIDOR_6)
	set_adjacent(Globals.Location.CORRIDOR_6, Globals.Location.COMPUTER)
	set_adjacent(Globals.Location.RECREATION_AREA, Globals.Location.MESS)
	set_adjacent(Globals.Location.AIRLOCK_2, Globals.Location.CORRIDOR_6)
	set_adjacent(Globals.Location.STORES_3, Globals.Location.CORRIDOR_6)
	
	# Middle deck
	locations[Globals.Location.COMMAND_CENTER] = Location.new(self, Globals.Location.COMMAND_CENTER, "Command Centre")
	locations[Globals.Location.INFIRMARY] = Location.new(self, Globals.Location.INFIRMARY, "Infirmary")
	locations[Globals.Location.CORRIDOR_1] = Location.new(self, Globals.Location.CORRIDOR_1, "Corridor 1")
	locations[Globals.Location.LABORATORY] = Location.new(self, Globals.Location.LABORATORY, "Laboratory")
	locations[Globals.Location.CORRIDOR_2] = Location.new(self, Globals.Location.CORRIDOR_2, "Corridor 2")
	locations[Globals.Location.INF_STORES] = Location.new(self, Globals.Location.INF_STORES, "Inf Stores")
	locations[Globals.Location.CRYO_VAULT] = Location.new(self, Globals.Location.CRYO_VAULT, "Cryo Vault")
	locations[Globals.Location.LAB_STORES] = Location.new(self, Globals.Location.LAB_STORES, "Lab Stores")
	locations[Globals.Location.ARMOURY] = Location.new(self, Globals.Location.ARMOURY, "Armoury")
	locations[Globals.Location.CORRIDOR_3] = Location.new(self, Globals.Location.CORRIDOR_3, "Corridor 3")
	locations[Globals.Location.CORRIDOR_4] = Location.new(self, Globals.Location.CORRIDOR_4, "Corridor 4")
	locations[Globals.Location.CORRIDOR_5] = Location.new(self, Globals.Location.CORRIDOR_5, "Corridor 5")
	locations[Globals.Location.STORES_1] = Location.new(self, Globals.Location.STORES_1, "Stores 1")
	locations[Globals.Location.ENGINE_1] = Location.new(self, Globals.Location.ENGINE_1, "Engine 1")
	locations[Globals.Location.ENGINE_2] = Location.new(self, Globals.Location.ENGINE_2, "Engine 2")
	locations[Globals.Location.ENGINE_3] = Location.new(self, Globals.Location.ENGINE_3, "Engine 3")
	
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
	locations[Globals.Location.SHUTTLE_STORE] = Location.new(self, Globals.Location.SHUTTLE_STORE, "Shuttle Store")
	locations[Globals.Location.CARGO_POD_1] = Location.new(self, Globals.Location.CARGO_POD_1, "Cargo Pod 1")
	locations[Globals.Location.SHUTTLE_BAY] = Location.new(self, Globals.Location.SHUTTLE_BAY, "Shuttle Bay")
	locations[Globals.Location.CARGO_POD_2] = Location.new(self, Globals.Location.CARGO_POD_2, "Cargo Pod 2")
	locations[Globals.Location.CORRIDOR_7] = Location.new(self, Globals.Location.CORRIDOR_7, "Corridor 7")
	locations[Globals.Location.LIFE_SUPPORT] = Location.new(self, Globals.Location.LIFE_SUPPORT, "Life Support")
	locations[Globals.Location.ENGINEERING] = Location.new(self, Globals.Location.ENGINEERING, "Engineering")
	locations[Globals.Location.ENG_STORES] = Location.new(self, Globals.Location.ENG_STORES, "Eng Stores")
	locations[Globals.Location.CARGO_POD_3] = Location.new(self, Globals.Location.CARGO_POD_3, "Cargo Pod 3")
	
	# Lower deck adjacent
	set_adjacent(Globals.Location.SHUTTLE_STORE, Globals.Location.SHUTTLE_BAY)
	set_adjacent(Globals.Location.CARGO_POD_1, Globals.Location.CARGO_POD_2)
	set_adjacent(Globals.Location.SHUTTLE_BAY, Globals.Location.CARGO_POD_2)
	set_adjacent(Globals.Location.CARGO_POD_2, Globals.Location.CORRIDOR_7)
	set_adjacent(Globals.Location.LIFE_SUPPORT, Globals.Location.CORRIDOR_7)
	set_adjacent(Globals.Location.SHUTTLE_BAY, Globals.Location.ENGINEERING)
	set_adjacent(Globals.Location.ENG_STORES, Globals.Location.ENGINEERING)
	set_adjacent(Globals.Location.CARGO_POD_2, Globals.Location.CARGO_POD_3)

	# Between floors
	set_adjacent(Globals.Location.CARGO_POD_2, Globals.Location.CORRIDOR_2)
	set_adjacent(Globals.Location.CORRIDOR_1, Globals.Location.LIVING_QUARTERS)
		
	# Crew
	crew[Globals.Crew.DALLAS] = Crewman.new(self, Globals.Crew.DALLAS, "Dallas", get_random_start_location_id(), true)
	crew[Globals.Crew.KANE] = Crewman.new(self, Globals.Crew.KANE, "Kane", get_random_start_location_id(), true)
	crew[Globals.Crew.RIPLEY] = Crewman.new(self, Globals.Crew.RIPLEY, "Ripley", get_random_start_location_id(), false)
	crew[Globals.Crew.ASH] = Crewman.new(self, Globals.Crew.ASH, "Ash", get_random_start_location_id(), true)
	crew[Globals.Crew.LAMBERT] = Crewman.new(self, Globals.Crew.LAMBERT, "Lambert", get_random_start_location_id(), false)
	crew[Globals.Crew.PARKER] = Crewman.new(self, Globals.Crew.PARKER, "Parker", get_random_start_location_id(), true)
	crew[Globals.Crew.BRETT] = Crewman.new(self, Globals.Crew.BRETT, "Brett", get_random_start_location_id(), true)
	
	# Choose alien
	alien_crew_id = Globals.rnd.randi_range(0, crew.size()-1)
	var alien_crew = crew[alien_crew_id]
	alien_crew.location.crew.erase(alien_crew)
	alien_crew.location = locations[get_random_location_id()]
	alien_crew.location.crew.push_back(alien_crew)

	# Choose Android
	var android_crew_id = Globals.rnd.randi_range(0, crew.size()-1)
	Globals.android = crew[android_crew_id]
	Globals.android.is_android = true
	
	# Items
	var _unused = Item.new(self, Globals.ItemType.SPANNER, Globals.Location.STORES_2)
	_unused = Item.new(self, Globals.ItemType.INCINERATOR, Globals.Location.COMMAND_CENTER)
	_unused = Item.new(self, Globals.ItemType.INCINERATOR, Globals.Location.COMMAND_CENTER)
	_unused = Item.new(self, Globals.ItemType.TRACKER, Globals.Location.COMMAND_CENTER)
	_unused = Item.new(self, Globals.ItemType.ELECTRIC_PROD, Globals.Location.INFIRMARY)
	_unused = Item.new(self, Globals.ItemType.CAT_BOX, Globals.Location.LABORATORY)
	_unused = Item.new(self, Globals.ItemType.ELECTRIC_PROD, Globals.Location.INF_STORES)
	_unused = Item.new(self, Globals.ItemType.LASER, Globals.Location.ARMOURY)
	_unused = Item.new(self, Globals.ItemType.LASER, Globals.Location.ARMOURY)
	_unused = Item.new(self, Globals.ItemType.LASER, Globals.Location.ARMOURY)
	_unused = Item.new(self, Globals.ItemType.FIRE_EXT, Globals.Location.ENGINE_1)
	_unused = Item.new(self, Globals.ItemType.FIRE_EXT, Globals.Location.ENGINE_2)
	_unused = Item.new(self, Globals.ItemType.FIRE_EXT, Globals.Location.ENGINE_3)
	_unused = Item.new(self, Globals.ItemType.ELECTRIC_PROD, Globals.Location.LAB_STORES)
	_unused = Item.new(self, Globals.ItemType.NET, Globals.Location.LAB_STORES)
	_unused = Item.new(self, Globals.ItemType.HARPOON, Globals.Location.SHUTTLE_BAY)
	_unused = Item.new(self, Globals.ItemType.INCINERATOR, Globals.Location.ENG_STORES)
	_unused = Item.new(self, Globals.ItemType.TRACKER, Globals.Location.ENG_STORES)

	jones = Jones.new(self, locations[get_random_location_id()])
	jones_moved()
	pass
	

func get_random_start_location_id():
	var x = Globals.rnd.randi_range(1, 2)
	if x == 1:
		return Globals.Location.COMMAND_CENTER
	else:
		return Globals.Location.MESS
	pass
		
func get_random_location_id():
	var loc_id = Globals.rnd.randi_range(0, locations.size()-1)
	return loc_id
	
	
func set_adjacent(loc1:int, loc2:int):
	locations[loc1].adjacent.push_back(locations[loc2])
	locations[loc2].adjacent.push_back(locations[loc1])
	pass
	
	
func append_log(s, color: Color = Color.white):
	$Log.add(s, color)
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
			$Audio/AudioStreamPlayer_CommandGiven.play()
	elif menu_mode == Globals.MenuMode.DROP:
		var item = find_item_by_type(selected_crewman.items, type)
		if item != null:
			var location : Location = selected_crewman.location#locations[selected_crewman.location]
			location.items.push_back(item)
			selected_crewman.items.erase(item)
			append_log(item.item_name + " dropped")
			set_menu_mode(Globals.MenuMode.NONE)
			$Audio/AudioStreamPlayer_CommandGiven.play()
	else:
		push_error("Unknown menu mode: " + str(menu_mode))
	pass
	

func find_item_by_type(items, type):
	for item in items:
		if item.type == type:
			return item
	
	return null
	

func _on_SfxTimer_timeout():
	pass


func crewman_wounded(crewman, amt:int):
	crewman.health -= amt
	if crewman.health <= 0:
		crewman_died(crewman)
	else:
		yield(get_tree().create_timer(.3), "timeout") # to give the attack sound time
		if crewman.male:
			$Audio/AudioStreamPlayer_MaleCrewPain.play()
		else:
			$Audio/AudioStreamPlayer_FemaleCrewPain.play()
	pass


func crewman_died(crewman : Crewman, scream:bool = true):
	if scream:
		$Audio/AudioStreamPlayer_MaleCrewDeath.play() # todo - female when I have one
	var item = Item.new(self, Globals.ItemType.CORPSE, crewman.location.id)
	item.item_name = "Body of " + crewman.crew_name
	crewman.died()
	if crewman == selected_crewman:
		selected_crewman = null
	if crewman == Globals.android:
		append_log("The Android has been killed", Color.red)
	refresh_ui = true
	
	# Check if game over
	var go = true
	for c in crew.values():
		if c.is_in_game() and c != Globals.android:
			go = false
			break;
	if go:
		if Globals.self_destruct_activated:
			ship_exploded()
		else:
			game_over()
		return
		
	yield(get_tree().create_timer(2), "timeout")
	$Audio/AudioStreamPlayer_Static.play()
	pass


func alien_combat(location : Location):
	if location.crew.size() <= 0:
		return
		
	var alien_attacks_crew = location.crew[Globals.rnd.randi_range(0, location.crew.size()-1)]
	$Audio/AudioStreamPlayer_AlienAttack.play()
	#append_log("The Alien attacks " + alien_attacks_crew.crew_name)
	crewman_wounded(alien_attacks_crew, Globals.rnd.randi_range(10, 40))

	for c in location.crew:
		if c.health < 50:
			continue
		if c.is_android:
			continue
		yield(get_tree().create_timer(.1), "timeout") # Wait to allow the areas ot be populated
		play_weapon_sfx(c.get_main_weapon_type())
		var alien_damage = c.get_main_weapon_alien_damage()
		alien.health -= Globals.rnd.randi_range(5, alien_damage)
		var location_damage = c.get_main_weapon_location_damage()
		location.damage += Globals.rnd.randi_range(5, location_damage)
		#append_log(c.crew_name + " attacks the Alien")
		# todo - if harpoon, kill crew
		if alien.health <= 0:
			alien_killed()
			return
		elif Globals.RELEASE_MODE == false:
			append_log("Alien health=" + str(alien.health))
		pass
		if android_activated == false and alien.health < 80:
#			append_log(android.crew_name + " is an ANDROID", Color.red)
			android_activated = true
			# Drop all equipment
			Globals.android.location.items.append_array(Globals.android.items)
			Globals.android.items.clear()
	pass
	

func activate_android():
	android_activated = true
	append_log(Globals.android.crew_name + " is an Android!", Color.red)
	pass
	
	
func android_combat():
	var location = Globals.android.location
	if location.crew.size() <= 1:
		return
		
	var android_attacks_crew = Globals.android
	while android_attacks_crew == Globals.android:
		android_attacks_crew = location.crew[Globals.rnd.randi_range(0, location.crew.size()-1)]
	#todo - sfx $Audio/AudioStreamPlayer_AndroidAttack.play()
	crewman_wounded(android_attacks_crew, Globals.rnd.randi_range(10, 20))
		
	for c in location.crew:
		if c.health < 50:
			continue
		if c.is_android:
			continue
		yield(get_tree().create_timer(.1), "timeout") # Wait to allow the areas ot be populated
		play_weapon_sfx(c.get_main_weapon_type())
		var android_damage = c.get_main_weapon_alien_damage()
		Globals.android.health -= Globals.rnd.randi_range(5, android_damage)
		if Globals.android.health <= 0:
			crewman_died(Globals.android, false)
			return
	pass
	

func play_weapon_sfx(type):
	match type:
		Globals.ItemType.INCINERATOR:
			$Audio/Flamethrower.play()
		Globals.ItemType.ELECTRIC_PROD:
			$Audio/Zap.play()
		Globals.ItemType.LASER:
			$Audio/Laser.play()
	pass
	
	
func alien_killed():
	append_log("The Alien has been killed")
	$Audio/AudioStreamPlayer_AlienDeath.play()
	alien = null
	game_over()
	pass
	
		
func _on_SelectUpperDeck_pressed():
	$Audio/AudioStreamPlayer_Click.play()
	$DeckNode/UpperDeck.visible = true
	$DeckNode/MiddleDeck.visible = false
	$DeckNode/LowerDeck.visible = false
	pass


func _on_SelectMiddleDeck_pressed():
	$Audio/AudioStreamPlayer_Click.play()
	$DeckNode/UpperDeck.visible = false
	$DeckNode/MiddleDeck.visible = true
	$DeckNode/LowerDeck.visible = false
	pass


func _on_SelectLowerDeck_pressed():
	$Audio/AudioStreamPlayer_Click.play()
	$DeckNode/UpperDeck.visible = false
	$DeckNode/MiddleDeck.visible = false
	$DeckNode/LowerDeck.visible = true
	pass


func start_autodestruct():
	self_destruct_time_left = Globals.SELF_DESTRUCT_TIME
	$Audio/AudioStreamPlayer_SelfDestruct.play()
	$Audio/AudioStreamPlayer_Alarm.play()
	Globals.self_destruct_activated = true
	$LabelSelfDestructTimeLeft.visible = true
	set_menu_mode(Globals.MenuMode.NONE)
	pass


func stop_autodestruct():
	if self_destruct_time_left < Globals.SELF_DESTRUCT_TIME / 2:
		$Audio/CannotCancelSelfDestruct.play()
		return

	$Audio/AudioStreamPlayer_Alarm.stop()
	$Audio/SelfDestructCancelled.play()
	Globals.self_destruct_activated = false
	$LabelSelfDestructTimeLeft.visible = false
	set_menu_mode(Globals.MenuMode.NONE)
	pass


func open_airlock1():
	if locations[Globals.Location.AIRLOCK_1].is_functioning() == false:
		append_log("The airlock is too damaged to open")
		return
		
	append_log("Airlock 1 open")
	$Audio/AirlockOpenClose.play()
	$Audio/AudioStreamPlayer_Airlock.play()
	for c in locations[Globals.Location.AIRLOCK_1].crew:
		append_log(c.crew_name + " has been sucked out of the airlock")
		crewman_died(c)
	if alien.location == locations[Globals.Location.AIRLOCK_1]:
		alien_killed()
	airlock1_open = true
	
	# Cancel destinations
	for c in crew.values():
		if c.destination == locations[Globals.Location.AIRLOCK_1]:
			c.destination = null
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	
	
func open_airlock2():
	if locations[Globals.Location.AIRLOCK_2].is_functioning() == false:
		append_log("The airlock is too damaged to open")
		return
		
	append_log("Airlock 2 open")
	$Audio/AirlockOpenClose.play()
	$Audio/AudioStreamPlayer_Airlock.play()
	for c in locations[Globals.Location.AIRLOCK_2].crew:
		append_log(c.crew_name + " has been sucked out of the airlock")
		crewman_died(c)
	if alien.location == locations[Globals.Location.AIRLOCK_2]:
		alien_killed()
	airlock2_open = true
	
	# Cancel destinations
	for c in crew.values():
		if c.destination == locations[Globals.Location.AIRLOCK_2]:
			c.destination = null
	set_menu_mode(Globals.MenuMode.NONE)
	pass
	
	
func close_airlock1():
	if locations[Globals.Location.AIRLOCK_1].is_functioning() == false:
		append_log("The airlock is too damaged to close")
		return
		
	$Audio/AirlockOpenClose.play()
	airlock1_open = false
	set_menu_mode(Globals.MenuMode.NONE)
	append_log("Airlock 1 closed")
	pass
	
	
func close_airlock2():
	if locations[Globals.Location.AIRLOCK_2].is_functioning() == false:
		append_log("The airlock is too damaged to close")
		return
		
	$Audio/AirlockOpenClose.play()
	airlock2_open = false
	set_menu_mode(Globals.MenuMode.NONE)
	append_log("Airlock 2 closed")
	pass
	
	
func _on_OneSecondTimer_timeout():
	if oxygen > 0:
		for c in crew.values():
			if c.is_in_game():
				oxygen -= 1

	if oxygen <= 0:
		oxygen = 0
		for c in crew.values():
			if c.is_in_game():
				c.health -= 1
				if c.health <= 0:
					crewman_died(c, false)
					
	# Check for tracker
	if alien == null:
		return
		
	jones.can_sense_alien = false
	for c in crew.values():
		if c.is_in_game():
			if find_item_by_type(c.items, Globals.ItemType.TRACKER) != null:
				if alien.location == c.location or is_location_adjacent(alien.location, c.location):
					$Audio/AudioStreamPlayer_Tracker.play()
					break
			if jones.caught_in != null:
				if c.items.has(jones.caught_in):
					if alien.location == c.location or is_location_adjacent(alien.location, c.location):
						#todo $Audio/AudioStreamPlayer_Tracker.play()
						jones.can_sense_alien = true
						break
		pass

#	yield(get_tree().create_timer(.4), "timeout") # Wait to allow the areas to be populated
#	if self_destruct_activated:
#		$Audio/AudioStreamPlayer_Alarm.play()  Annoying?

	pass


func enter_hypersleep():
	if locations[Globals.Location.CRYO_VAULT].is_functioning() == false:
		append_log("The cryo chambers are too damaged to launch")
		return
	if alien != null and alien.location.id == Globals.Location.CRYO_VAULT:
		append_log("Cannot enter hypersleep while alien present")
		return
		
	$Audio/AudioStreamPlayer_Hypersleep.play()
	$Audio/HypersleepActivated.play()
	selected_crewman.in_cryo = true
	append_log(selected_crewman.crew_name + " has entered hypersleep")
	selected_crewman = null
	refresh_ui = true
	pass
	

func damage_location(loc):
	$Audio/AudioStreamPlayer_Crash.play()
	loc.damage += Globals.rnd.randi_range(5, 20)
	pass
	

func game_over():
	yield(get_tree().create_timer(3), "timeout")

	Globals.data["crew"] = crew
	Globals.data["alien"] = alien
	var _unused = get_tree().change_scene("res://GameOverScene.tscn")
	pass
	

func ship_exploded(): # Exploded and shuttle NOT launched
	$Audio/BigExplosion.play()
	alien = null
	for c in crew.values():
		c.health = 0
	game_over()
	pass
	
	
func cryo_destroyed():
	$Audio/SmallExplosion.play()
	for c in crew.values():
		if c.in_cryo:
			append_log(c.crew_name + " has died in cryo", Color.red)
			c.in_cryo = false
			c.health  = 0
	pass
	

func activate_location(location):
	location.activated = true
	if location.id == Globals.Location.INFIRMARY:
		$Audio/InfirmeryActivated.play()
	pass
	
	
func launch_narcissus():
	if locations[Globals.Location.SHUTTLE_BAY].is_functioning() == false:
		append_log("The shuttle is too damaged to launch")
		return
		
	if jones.caught_in == null:
		append_log("You have not caught Jones yet")
		return
	
	var num_alive = 0
	var num_hypersleep = 0
	var not_in_location = 0
	for c in crew.values():
		if c.in_cryo:
			num_hypersleep += 1
		elif c.health > 0 and c.is_android == false:
			num_alive += 1
			if c.location.id != Globals.Location.SHUTTLE_BAY:
				not_in_location += 1
			
	if num_hypersleep > 0:
		append_log("You cannot launch the shuttle because at least one member of the crew is in hypersleep", Color.yellow)
		return
	elif not_in_location > 0:
		append_log("Not all the remaining crew are here", Color.yellow)
		return
	elif num_alive > 3:
		append_log("Only 3 crewmembers can fit inside the shuttle", Color.yellow)
		return
	elif Globals.self_destruct_activated == false:
		append_log("Launch only possible after self-destruct has been activated", Color.yellow)
		return
	elif alien != null and alien.location.id == Globals.Location.SHUTTLE_BAY:
		append_log("The alien is here!", Color.yellow)
		return
		
	$Audio/LaunchShuttle.play()
	Globals.shuttle_launched = true
	
	if Globals.self_destruct_activated:
		alien = null
		for c in crew.values():
			if c.location.id != Globals.Location.SHUTTLE_BAY:
				c.health = 0
		
	game_over()
	pass
	
	
func try_and_catch_jones(crewman):
	var item : Item = find_item_by_type(crewman.items, Globals.ItemType.NET)
	if item == null:
		item = find_item_by_type(crewman.items, Globals.ItemType.CAT_BOX)
	if item != null:
		var success = Globals.rnd.randi_range(1, 2) == 1
		if success:
			jones.caught_in = item
			jones.location = null
			append_log(crewman.crew_name + " has caught Jones in the " + item.item_name, Color.green)
			item.item_name = item.item_name + " with Jones"
			$Audio/AudioStreamPlayer_JonesCaught.play() # todo - change
			refresh_ui = true
		else:
			append_log(crewman.crew_name + " failed to catch Jones", Color.green)
	pass
