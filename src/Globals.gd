extends Node

enum Crew {DALLAS, KANE, RIPLEY, ASH, LAMBERT, PARKER, BRETT}

enum ItemType {CAT_BASKET, FLAMETHROWER}

enum Location {COMMAND_CENTER, CORRIDOR_1, INFIRMARY, LABORATORY, CORRIDOR_2, CORRIDOR_3, CORRIDOR_4, CORRIDOR_5,
				INF_STORES, ARMOURY, ENGINE_1, CRYO_VAULT, LAB_STORES, STORES_1, ENGINE_2, ENGINE_3}

enum MenuMode {NONE, GO_TO, PICK_UP, USE, SPECIAL}

var rnd : RandomNumberGenerator

func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	pass
