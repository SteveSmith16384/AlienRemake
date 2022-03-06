extends Node2D


func _ready():
	if Globals.RELEASE_MODE:
		OS.window_fullscreen = true

	$AudioStreamPlayer_Music.play()
	
	$Version.text = "VERSION " + Globals.VERSION
	
	$Log.add("You are in command of the crew of the Nostromo.")
	$Log.add("You must ensure they survive the encounter")
	$Log.add("with whatever awaits them.")
	$Log.add("")
	$Log.add("Good luck.")
	$Log.add("Click anywhere on your console to continue.")
	pass


func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		$AudioStreamPlayer_Click.play()
		OS.window_fullscreen = !OS.window_fullscreen

	if Input.is_mouse_button_pressed(1):
		var _unused = get_tree().change_scene("res://World.tscn")
	pass
	
	
