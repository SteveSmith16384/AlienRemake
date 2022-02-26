extends Node2D

const log_entry_class = preload("res://LogEntry.tscn")

func add(s, clear:bool = false):
	if clear:
		clear_log()
	var log_entry = log_entry_class.instance()
	log_entry.text = s
	$VBoxContainer.add_child(log_entry)
	while $VBoxContainer.get_child_count() > 6:
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
	
