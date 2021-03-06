extends Control
class_name HUD
func is_class(value: String): return value == "HUD" or .is_class(value)
func get_class() -> String: return "HUD"

onready var button_container : GridContainer = $CanvasLayer/Panel/GridContainer
onready var placeholder_container_node : Node = $PlaceHolderContainer
onready var gcpb : TextureButton = get_node("CanvasLayer/GalacticCenterPopupButton")
onready var gcpbwd : WindowDialog = gcpb.get_node("WindowDialog")
var gcpbs : bool = false

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	var __ = gcpb.connect("button_down", self, "_on_gcpb_button_down")
	__ = gcpbwd.get_close_button().connect("button_down", self, "_on_windowdialog_close_button_down")
	__ = GAME.connect("unlock_gc", self, "_on_unlock_gc")
	var instantiate_element_button_scene : PackedScene = GAME.ELEMENT_BUTTON_SCENE
	for el in GAME.get_elements().size():
		var iebs_instance = instantiate_element_button_scene.instance()
		
		var el_i = GAME.get_elements()[el].get("scene").instance()
		var el_i_id = el_i.get_id()
		var el_i_name = el_i.get_name()
		var el_i_texture = el_i.get_rep_sprite()
		
		var should_disable : bool = true if not GAME.is_element_unlocked_by_id(el_i_id) else false
		
		iebs_instance._setup(el_i_id, el_i_name, el_i_texture, should_disable)
		button_container.add_child(iebs_instance, true)
		iebs_instance.set_owner(self)

#### VIRTUALS ####



#### LOGIC ####

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_gcpb_button_down() -> void:
	if not gcpbs:
		gcpbwd.popup()
	else:
		gcpbwd.hide()
	gcpbs = !gcpbs

func _on_windowdialog_close_button_down() -> void:
	gcpbs = !gcpbs

func _on_Panel_mouse_entered() -> void:
	GAME._set_cursor_in_select(true)

func _on_Panel_mouse_exited() -> void:
	GAME._set_cursor_in_select(false)

func _on_unlock_gc() -> void:
	gcpb.set_visible(true)
