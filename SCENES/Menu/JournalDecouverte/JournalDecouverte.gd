extends Control
class_name JournalDecouverte
func is_class(value: String): return value == "JournalDecouverte" or .is_class(value)
func get_class() -> String: return "JournalDecouverte"

## VARIABLES

# SCENE
onready var journal_elements_container : GridContainer = get_node_or_null("CanvasLayer/ScrollContainer/ElementsContainer")
onready var journalelement_scene : PackedScene = preload("res://SCENES/Menu/JournalDecouverte/JournalElement/JournalElement.tscn")

# ONREADY
onready var retour_button : Button = get_node_or_null("CanvasLayer/Retour")
onready var reprendre_button : Button = get_node_or_null("CanvasLayer/Reprendre")

onready var journal_element_ldescr : RichTextLabel = get_node_or_null("CanvasLayer/LongDescrPanel/RichTextLabel")
# EXPORTED

# VAR
const UNDERLINES : Array = ["[u]","[/u]"]
const BOLD : Array = ["[b]","[/b]"]
const CENTER : Array = ["[center]","[/center]"]
const COLORAQUA : Array = ["[color=aqua]","[/color]"]
const COLORYELLOW : Array = ["[color=yellow]","[/color]"]

const LONG_DESCR_WINDOW_TITLE : String = "[color=green]DESCRIPTION DETAILLEE[/color]"
var LONG_DESCR_WINDOW_ELEMENT_NAME : String = ""
var LONG_DESCR_WINDOW_ELEMENT_LDESCR : String = ""

## NATIVE

func _ready() -> void:
	var __
	
	retour_button.set_visible(false)
	reprendre_button.set_visible(false)
	
	if GAME.sceneclass_opening_journal == "TitleScreen":
		__ = retour_button.connect("button_down", self, "_on_retour")
		retour_button.set_visible(true)
	elif GAME.sceneclass_opening_journal  == "PauseScene":
		__ = reprendre_button.connect("button_down", self, "_on_reprendre")
		reprendre_button.set_visible(true)
	else:
		push_error("Opening Journal Scene from Null Scene")
	
	_setup_journal_grid()

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if Input.is_action_just_pressed("menu"):
		call_deferred("queue_free")

## LOGIC

func _setup_journal_grid() -> void:
	for e in GAME.get_elements():
		var new_journal_element = journalelement_scene.instance()
		
		var space_element = GAME.get_element_scene_by_id(e).instance()
		if space_element == null: return
		
		new_journal_element._init_placeholder_values(space_element.get_id(), space_element.get_name(), space_element.get_rep_sprite())
		journal_elements_container.call_deferred("add_child", new_journal_element, true)
		
		yield(new_journal_element, "ready")
		new_journal_element.set_owner(self)
		new_journal_element._setup()

func set_element_ldescr(jel) -> void:
	var ei : int = jel.get_element_id() if not jel is int else jel
	var en = GAME.get_element_frname_by_id(ei)
	
	journal_element_ldescr.set_bbcode(
		LONG_DESCR_WINDOW_TITLE \
		+ "\n\n\n" \
		+ COLORAQUA[0] + CENTER[0] + UNDERLINES[0] + en + UNDERLINES[1] + CENTER[1] + COLORAQUA[1] \
		+ "\n\n\n" \
		+ GAME.get_element_ldescr_by_id(ei) \
		+ "\n\n\n" \
		+ COLORYELLOW[0] + GAME.get_element_merge_by_id(ei) + COLORYELLOW[1]
	)

## VIRTUALS

## SIGNALS
func _on_retour() -> void:
	var __ = get_tree().change_scene(GAME.TITLESCREEN)

func _on_reprendre() -> void:
	call_deferred("queue_free")

func _on_JournalDecouverte_tree_exiting() -> void:
	GAME.sceneclass_opening_journal = ""

# FROM JOURNAL ELEMENT
func _on_journal_element_mouse_entered(journal_element) -> void:
	if journal_element.is_journal_element_unlocked():
		set_element_ldescr(journal_element)

func _on_journal_element_mouse_exited(journal_element) -> void:
	pass
