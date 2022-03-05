extends Node2D

export var MaxLines:int = 8
const log_entry_class = preload("res://LogEntry.tscn")

func add(s, colour):
	var log_entry = log_entry_class.instance()
	log_entry.text = s
	log_entry.set_colour(colour)
	$VBoxContainer.add_child(log_entry)
	while $VBoxContainer.get_child_count() > MaxLines:
		var child: Label = $VBoxContainer.get_child(0)
		$VBoxContainer.remove_child(child)
		child.call_deferred("queue_free")
	pass
	

func clear_log():
	while $VBoxContainer.get_child_count() > 0:
		var child: Label = $VBoxContainer.get_child(0)
		$VBoxContainer.remove_child(child)
		child.call_deferred("queue_free")
	pass
	
