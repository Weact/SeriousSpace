extends Control
class_name TitleScreen
func is_class(value: String): return value == "TitleScreen" or .is_class(value)
func get_class() -> String: return "TitleScreen"

onready var hbox_buttonscontainer_node : HBoxContainer = $ButtonsContainer
onready var btn_jouer_node : Button = hbox_buttonscontainer_node.get_node("VContainer/Jouer")
onready var btn_journal_node : Button = hbox_buttonscontainer_node.get_node("VContainer/Journal")
onready var btn_quitter_node : Button = hbox_buttonscontainer_node.get_node("VContainer/Quitter")

func _ready() -> void:
	get_tree().set_pause(false)
	GAME.set_game_paused(false)
	
	var __
	__ = btn_jouer_node.connect("button_down", self, "_on_jouer")
	__ = btn_journal_node.connect("button_down", self, "_on_journal")
	__ = btn_quitter_node.connect("button_down", self, "_on_quitter")
	


### SIGNALS

func _on_jouer() -> void:
	var __ = get_tree().change_scene(GAME.LEVEL)

func _on_journal() -> void:
	GAME.sceneclass_opening_journal = get_class()
	call_deferred("add_child", load(GAME.JOURNAL).instance() )

func _on_quitter() -> void:
	get_tree().quit()
