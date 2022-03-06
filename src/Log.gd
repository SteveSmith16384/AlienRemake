extends Node2D

export var MaxLines:int = 8
export var interval: float = 0.3

const log_entry_class = preload("res://LogEntry.tscn")

var lines = []

func _ready():
	$Timer.wait_time = interval
	pass
	
	
func add(s, colour: Color = Color.white):
	var log_entry = log_entry_class.instance()
	log_entry.text = s
	log_entry.set_colour(colour)
	lines.push_back(log_entry)
	pass
	
	
func clear_log():
	while $VBoxContainer.get_child_count() > 0:
		var child: Label = $VBoxContainer.get_child(0)
		$VBoxContainer.remove_child(child)
		child.call_deferred("queue_free")
	pass
	

func _on_Timer_timeout():
	if lines.size() == 0:
		return
	
	var log_entry = lines[0]
	lines.remove(0)
	$VBoxContainer.add_child(log_entry)
	if log_entry.text.length() > 0:
		$AudioStreamPlayer_Text.play()
	
	while $VBoxContainer.get_child_count() > MaxLines:
		var child: Label = $VBoxContainer.get_child(0)
		$VBoxContainer.remove_child(child)
		child.call_deferred("queue_free")
	pass
	
