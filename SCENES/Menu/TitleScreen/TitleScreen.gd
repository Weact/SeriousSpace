extends Control
class_name Menu_TitleScreen

const LEVEL_PATH = "res://SCENES/Level/Level.tscn"

onready var hbox_buttonscontainer_node : HBoxContainer = $ButtonsContainer
onready var btn_jouer_node : Button = hbox_buttonscontainer_node.get_node("VContainer/Jouer")
onready var btn_journal_node : Button = hbox_buttonscontainer_node.get_node("VContainer/Journal")
onready var btn_quitter_node : Button = hbox_buttonscontainer_node.get_node("VContainer/Quitter")

func _ready() -> void:
	var __
	__ = btn_jouer_node.connect("button_down", self, "_on_jouer")
	__ = btn_journal_node.connect("button_down", self, "_on_journal")
	__ = btn_quitter_node.connect("button_down", self, "_on_quitter")


### SIGNALS

func _on_jouer() -> void:
	var __ = get_tree().change_scene(LEVEL_PATH)

func _on_journal() -> void:
	pass

func _on_quitter() -> void:
	get_tree().quit()
