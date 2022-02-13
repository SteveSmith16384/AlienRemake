extends Label

const SPACES = "        "#      "

var queue = []
var current_text : String = ""
var current_pos : int = 0

func add_text(s):
	# Check if it's a dupe
	if queue.size() > 0:
		if queue[queue.size()-1] == s + SPACES:
			return
	
	if queue.size() == 0 and current_text.length() == 0:
		current_text = s + SPACES
		current_pos = 0
		$AudioStreamPlayer_NewText.play()
	else:
		queue.push_back(s + SPACES)
		
	$Timer.start()
	pass
	

func _on_Timer_timeout():
	current_pos += 1
	if current_pos < current_text.length():
		text = current_text.substr(0, current_pos)
	else:
		if queue.size() > 0:
			var s = queue.pop_front()
			current_text = s
			current_pos = 0
			$AudioStreamPlayer_NewText.play()
		else:
			current_text = ""
			$Timer.stop()
	pass
