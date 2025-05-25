extends Node

const VERSION = "1.3"
const RELEASE_MODE = true

const SHOW_ALIEN = false and RELEASE_MODE == false

# If you add any here, don't forget to to add them to reset()
var self_destruct_activated = false
var shuttle_launched = false
var android : Crewman
var data = {}

const OXYGEN: int = 7500
const SELF_DESTRUCT_TIME = 600
 
enum Crew {DALLAS, KANE, RIPLEY, ASH, LAMBERT, PARKER, BRETT}

enum ItemType {CAT_BOX, INCINERATOR, LASER, ELECTRIC_PROD, NET, SPANNER, HARPOON,
				FIRE_EXT, TRACKER, CORPSE}

enum Location {COMMAND_CENTER, CORRIDOR_1, INFIRMARY, LABORATORY, CORRIDOR_2, CORRIDOR_3, CORRIDOR_4, CORRIDOR_5,
				INF_STORES, ARMOURY, ENGINE_1, CRYO_VAULT, LAB_STORES, STORES_1, ENGINE_2, ENGINE_3, LIVING_QUARTERS, 
				AIRLOCK_1, AIRLOCK_2, MESS, STORES_2, STORES_3, CORRIDOR_6,
				COMPUTER, RECREATION_AREA, SHUTTLE_STORE, CARGO_POD_1, CARGO_POD_2, CARGO_POD_3,
				ENGINEERING, ENG_STORES, SHUTTLE_BAY, CORRIDOR_7, LIFE_SUPPORT}

enum MenuMode {NONE, GO_TO, PICK_UP, DROP, USE, SPECIAL}

var rnd : RandomNumberGenerator

func _ready():
	rnd = RandomNumberGenerator.new()
	rnd.randomize()
	
#	if RELEASE_MODE == false:
#		SELF_DESTRUCT_TIME = 10
#		shuttle_launched = true
	pass


func reset():
	self_destruct_activated = false
	shuttle_launched = false
	data = {}
	android = null
	pass
	
