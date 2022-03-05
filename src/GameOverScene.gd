extends Node2D

func _ready():
	$Log.add("Game Over")
	$Log.add("Crew Status:")
	
	var crew = Globals.data["crew"]
	for c in crew.values():
		if c.in_cryo:
			$Log.add(c.crew_name + ": in hypersleep")
		elif c.health <= 0:
			$Log.add(c.crew_name + ": DEAD")
		else:
			$Log.add(c.crew_name + ": Survived")

	$Log.add("Alien Status:")
	var alien = Globals.data["alien"]
	if alien == null:
		$Log.add("DEAD")
		$Log.add("Well Done!")
	else:
		$Log.add("Alive")
		$Log.add("The alien made it to earth and destroyed the human civilisation.")
	pass
