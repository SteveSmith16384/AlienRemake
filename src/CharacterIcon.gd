extends Node2D

export var crew_name : String
export(String, FILE) var image_path

func _ready():
	$VBoxContainer/Label_Name.text = crew_name
	$VBoxContainer/TextureRect.texture = load(image_path)
	pass
	
	
