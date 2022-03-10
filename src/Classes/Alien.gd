class_name Alien
extends Node

enum Mode {NONE, MOVE, REMAIN, DAMAGE}

var main
var location : Location
var action_time : float
var health : int = 100
var current_mode = Mode.NONE
var moves_since_last_deck_change:int = 0

func _init(_main, loc : Location):
	main = _main
	location = loc
	pass
	

func _process(delta):
	if health <= 0:
		return
	
	if current_mode == Mode.NONE:
		if location.crew.size() == 1:
			current_mode = Mode.ATTACK
			action_time = 3
		elif location.crew.size() > 1 or Globals.rnd.randi_range(1, 5) <= 4:
			current_mode = Mode.MOVE
			action_time = 9
		else:
			current_mode = Mode.DAMAGE
			action_time = 9
		action_time = action_time * 100 / health
		return
		
	action_time -= delta
	if action_time <= 0:
		# Check if a crewmember has arrived in the meantime
		if location.crew.size() == 1:
			current_mode = Mode.REMAIN

		if current_mode == Mode.REMAIN:
			#main.alien_combat(location) Now happens in seperate timer
			pass
		elif current_mode == Mode.DAMAGE:
			main.damage_location(location)
		elif current_mode == Mode.MOVE:
			move()
		current_mode = Mode.NONE
	pass
	
	
func move():
	# Change decks?
	if moves_since_last_deck_change >= 2: # 2 so it doesn't keep moving back to ladder room and going back up/down
		if location.id == Globals.Location.CARGO_POD_2:
			location = main.locations[Globals.Location.CORRIDOR_2]
		elif location.id == Globals.Location.CORRIDOR_2:
			location = main.locations[Globals.Location.CARGO_POD_2]
		elif location.id == Globals.Location.CORRIDOR_1:
			location = main.locations[Globals.Location.LIVING_QUARTERS]
		elif location.id == Globals.Location.LIVING_QUARTERS:
			location = main.locations[Globals.Location.CORRIDOR_1]
		moves_since_last_deck_change = 0
		main.alien_moved()
		return
		
	var adj = location.adjacent
	for _idx in range(3): # try 4 times
		var loc = adj[Globals.rnd.randi_range(0, adj.size()-1)]
		if loc.crew.size() <= 1:
			location = loc
			main.alien_moved()
			moves_since_last_deck_change += 1
			return
			
	current_mode = Mode.DAMAGE # Since we can't move
	pass


