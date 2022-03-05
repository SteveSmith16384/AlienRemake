class_name Alien
extends Node

enum Mode {NONE, MOVE, ATTACK, DAMAGE}

var main
var location : Location
#var destination : Location
var action_time : float
var health : int = 100
var current_mode = Mode.NONE

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
		elif location.crew.size() > 1 or Globals.rnd.randi_range(1, 4) < 5:
			current_mode = Mode.MOVE
			action_time = 9
		else:
			current_mode = Mode.DAMAGE
			action_time = 9
		return

		
	action_time -= delta
	if action_time <= 0:
		# Check if a crewmember has arrived in the meantime
		if location.crew.size() == 1:
			current_mode = Mode.ATTACK

		if current_mode == Mode.ATTACK:
			main.combat(location)
		elif current_mode == Mode.DAMAGE:
			main.damage_location(location)
		elif current_mode == Mode.MOVE:
			move()
		current_mode = Mode.NONE
	pass
	
	
func move():
	var adj = location.adjacent
	location = adj[Globals.rnd.randi_range(0, adj.size()-1)] # todo - check if empty
	main.alien_moved()
	pass


