extends CanvasLayer
class_name PauseScene
func is_class(value: String):return value == "PauseScene" or .is_class(value)
func get_class() -> String:return "PauseScene"

onready var reprendre : Button = get_node("SCREEN/Boutons/Reprendre")
onready var journal : Button = get_node("SCREEN/Boutons/Journal")
onready var quitter : Button = get_node("SCREEN/Boutons/Quitter")

#### ACCESSORS ####

func is_journal_open() -> bool:
	for c in get_children():
		if c.get_name() == "JournalDecouverte":
			return true
	return false

#### BUILT-IN ####

func _ready() -> void:
	var __
	__ = reprendre.connect("button_down", self, "_on_reprendre")
	__ = journal.connect("button_down", self, "_on_journal")
	__ = quitter.connect("button_down", self, "_on_quitter")
	
	get_tree().set_pause(true)
	GAME.set_game_paused(true)
	if GAME.DEBUG: print("Paused the game")

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if Input.is_action_just_pressed("menu") and get_tree().is_paused():
		call_deferred("queue_free")

#### LOGIC ####

#### VIRTUALS ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
func _on_reprendre() -> void:
	call_deferred("queue_free")

func _on_journal() -> void:
	if is_journal_open(): return
	
	GAME.sceneclass_opening_journal = get_class()
	call_deferred("add_child", load(GAME.JOURNAL).instance() )

func _on_quitter() -> void:
	var __ = get_tree().change_scene(GAME.TITLESCREEN)


func _on_PauseScene_tree_exiting() -> void:
	get_tree().set_pause(false)
	GAME.set_game_paused(false)
	if GAME.DEBUG: print("Unpaused the game")
