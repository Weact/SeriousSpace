extends Node2D
class_name Level
func is_class(value: String): return value == "Level" or .is_class(value)
func get_class() -> String: return "Level"

onready var darkmatters_container_node : Node = get_node_or_null("Objects/DarkMatters")
onready var cosmicdusts_container_node : Node = get_node_or_null("Objects/CosmicDusts")
onready var meteroids_container_node : Node = get_node_or_null("Objects/Meteroids")
onready var planets_container_node : Node = get_node_or_null("Objects/Planets")
onready var stars_container_node : Node = get_node_or_null("Objects/Stars")
onready var blackholes_container_node : Node = get_node_or_null("Objects/BlackHoles")
onready var galaxy_container_node : Node = get_node_or_null("Objects/Galaxies")

onready var containers : Array = [
	darkmatters_container_node,
	cosmicdusts_container_node,
	meteroids_container_node,
	planets_container_node,
	stars_container_node,
	blackholes_container_node,
	galaxy_container_node
	]

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	if GAME.DEBUG:
		print("Game initialization by " + get_name() + "...")
		
	MergeHandler.init()
	_init_containers_nodes_path()
	
	if GAME.DEBUG:
		print("Level is ready, game initialization is done!")

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if Input.is_action_just_pressed("menu") and not get_tree().is_paused():
		call_deferred("add_child", load(GAME.PAUSESCREEN).instance() )

#### VIRTUALS ####



#### LOGIC ####

func _init_containers_nodes_path() -> void:
	GAME.objects_container_nodes = containers.duplicate(true)

#### INPUTS ####



#### SIGNAL RESPONSES ####
