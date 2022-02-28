extends Node

const VERSION = "0.1"
const RELEASE_MODE = false

const START_TIME: int = 60 * 60

enum Crew {DALLAS, KANE, RIPLEY, ASH, LAMBERT, PARKER, BRETT}

enum ItemType {CAT_BOX, INCINERATOR, LASER, ELECTRIC_PROD, NET, SPANNER, HARPOON,
				FIRE_EXT, TRACKER, CORPSE}

enum Location {COMMAND_CENTER, CORRIDOR_1, INFIRMARY, LABORATORY, CORRIDOR_2, CORRIDOR_3, CORRIDOR_4, CORRIDOR_5,
				INF_STORES, ARMOURY, ENGINE_1, CRYO_VAULT, LAB_STORES, STORES_1, ENGINE_2, ENGINE_3}

enum MenuMode {NONE, GO_TO, PICK_UP, DROP, USE, SPECIAL}

var rnd : RandomNumberGenerator

func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	pass

