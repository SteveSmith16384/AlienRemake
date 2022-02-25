extends Node2D

const log_entry_class = preload("res://LogEntry.tscn")

func _ready():
	pass # Replace with function body.


func add(s):
	var log_entry = log_entry_class.instance()
	log_entry.text = s
	$VBoxContainer.add_child(log_entry)
	while $VBoxContainer.get_child_count() > 6:
		$VBoxContainer.get_child(0).queue_free()
	pass
	
