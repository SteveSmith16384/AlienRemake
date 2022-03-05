extends Node2D


func _ready():
	if Globals.RELEASE_MODE:
		OS.window_fullscreen = true

	pass
