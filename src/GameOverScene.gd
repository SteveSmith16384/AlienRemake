extends Node2D

var allow_click = false

func _ready():
	$AudioStreamPlayer_Music.play()
	
	$Log.add("Game Over")
	$Log.add("")
	$Log.add("Crew Status:")
	
	var num_alive:int = 0
	var crew = Globals.data["crew"]
	for c in crew.values():
		if c.health <= 0:
			$Log.add(c.crew_name + ": DEAD", Color.red)
		elif c.in_cryo:
			num_alive += 1
			$Log.add(c.crew_name + ": In Hypersleep, " + c.get_health_string())
		else:
			num_alive += 1
			$Log.add(c.crew_name + ": Survived, " + c.get_health_string())

	$Log.add("")
	$Log.add(Globals.android.crew_name + " was an Android")
	$Log.add("")
	$Log.add("Alien Status:")
	var alien = Globals.data["alien"]
	if alien == null:
		$Log.add("* DEAD *")
	else:
		$Log.add("Alive", Color.red)
		$Log.add("")
		$Log.add("The alien made it to earth and destroyed the human civilisation.", Color.red)
		#$Log.add("You have failed this time", Color.red)

	$Log.add("")
	$Log.add("Mission Summary:")
	if Globals.self_destruct_activated == false:
		if alien != null:
			$Log.add("Complete Failure.  0%")
		else: # Alien dead
			var score = num_alive * 14
			$Log.add("Success: " + str(score) + "%", Color.green)
			$Log.add("Well Done!")
			$Log.add("")
			$Log.add("You have been asked to command a unit of marines")
			$Log.add("who are to investigate the colony")
			$Log.add("on LV-426")
	else: # Self destruct activated, so alien must be dead
		if num_alive == 0:
			$Log.add("Failure.  5%", Color.red)
		else:
			var score = num_alive * 7
			$Log.add("Score: " + str(score) + "%", Color.green)
	pass


func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		$AudioStreamPlayer_Click.play()
		OS.window_fullscreen = !OS.window_fullscreen
	pass
	


func _on_RestartButton_pressed():
	var _unused = get_tree().change_scene("res://IntroScene.tscn")
	pass
