extends Node2D

func _ready():
	$AudioStreamPlayer_Music.play()
	
	$Log.add("Game Over")
	$Log.add("Crew Status:")
	
	var crew = Globals.data["crew"]
	for c in crew.values():
		if c.health <= 0:
			$Log.add(c.crew_name + ": DEAD", Color.red)
		elif c.in_cryo:
			$Log.add(c.crew_name + ": In Hypersleep")
		else:
			$Log.add(c.crew_name + ": Survived")

	$Log.add("Alien Status:")
	var alien = Globals.data["alien"]
	if alien == null:
		$Log.add("* DEAD *")
		$Log.add("Well Done!")
		$Log.add("")
		$Log.add("You have been asked to command a unit of marines")
		$Log.add("who are to investigate the colony")
		$Log.add("on LV-426")
	else:
		$Log.add("Alive", Color.red)
		$Log.add("The alien made it to earth and destroyed the human civilisation.")
		$Log.add("")
		$Log.add("You failed this time", Color.red)
	pass


func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		$AudioStreamPlayer_Click.play()
		OS.window_fullscreen = !OS.window_fullscreen

	if Input.is_mouse_button_pressed(1):
		var _unused = get_tree().change_scene("res://World.tscn")
	pass
	
