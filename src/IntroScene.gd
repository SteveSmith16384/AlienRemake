extends Node2D

var allow_click = false

func _ready():
	if Globals.RELEASE_MODE:
		OS.window_fullscreen = true

	$AudioStreamPlayer_Music.play()
	
	$Version.text = "VERSION " + Globals.VERSION
	
	var colour = Color.green
	$Log.add("You are in command of the crew of the Nostromo.", colour)
	$Log.add("You must ensure they survive the encounter", colour)
	$Log.add("with whatever awaits them.", colour)
	$Log.add("")
	$Log.add("Good luck.", colour)
	pass


func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		$AudioStreamPlayer_Click.play()
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	pass
	
	
func _on_StartButton_pressed():
	var _unused = get_tree().change_scene("res://World.tscn")
	pass


func _on_ToggleFullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	pass
