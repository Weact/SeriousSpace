extends TextureButton
class_name ElementButton

func is_class(value: String): return value == "ElementButton" or .is_class(value)
func get_class() -> String: return "ElementButton"

onready var ipanel : Panel = get_node_or_null("InformationPanel")

var el_id : int = -1
var el_name : String = ""
var el_pre : Texture = null
var el_descr : String = ""

#### ACCESSORS ####

func set_button_name(n : String) -> void:
	el_name = n
	set_name(el_name)

func set_id(i: int) -> void:
	el_id = i

func set_pre(p: Texture) -> void:
	el_pre = p
	set_normal_texture(el_pre)
	set_disabled_texture(el_pre)

func set_button_disabled(d: bool) -> void:
	disabled = d
	if disabled:
		set_modulate( Color(0.3, 0.3, 0.3, 1.0) )
	else:
		set_modulate( Color(1.0, 1.0, 1.0, 1.0) )
	set_disabled(disabled)

func set_descr(descr: String) -> void:
	el_descr = descr
	var ipanel_text = ipanel.get_node("Information")
	ipanel_text.set_text(el_descr)

#### BUILT-IN ####

func _setup(id: int, name: String, pre: Texture, should_disable : bool) -> void:
	_init_button_values(id, name, pre, should_disable)
	
	var __
	__ = connect("button_down", self, "_on_element_button_down", [self])
	__ = connect("mouse_entered", self, "_on_element_mouse_entered", [self])
	__ = connect("mouse_exited", self, "_on_element_mouse_exited", [self])
	__ = GAME.connect("element_unlocked", self, "_on_element_unlocked")
	
	yield(self, "ready")
	set_descr(GAME.get_element_sdescr_by_id(id))

#### VIRTUALS ####



#### LOGIC ####

func _init_button_values(e_id: int, e_name: String, e_pre: Texture, e_should_disable : bool) -> void:
	var prefix : String = "_ElementButton"
	set_id(e_id)
	set_button_name(e_name + prefix)
	set_pre(e_pre)
	set_button_disabled(e_should_disable)

func _create_element_placeholder() -> void:
	var placeholder_container = get_owner().placeholder_container_node if get_owner() != null or get_owner().is_class("HUD") else null
	if not is_instance_valid(placeholder_container):
		push_error("Trying to create element placeholder to a null owner or not HUD")
		return
		
	var new_placeholder : TextureRect = GAME.ELEMENT_PLACEHOLDER_SCENE.instance()
	new_placeholder._init_placeholder_values(el_id, el_name, el_pre)
	placeholder_container.add_child(new_placeholder, true)
	new_placeholder._setup()

func _show_information() -> void:
	if not is_disabled():
		ipanel.set_visible(true)

func _hide_information() -> void:
	if not is_disabled():
		ipanel.set_visible(false)

#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_element_button_down(_button: TextureButton) -> void:
	_create_element_placeholder()

func _on_element_mouse_entered(_button: TextureButton) -> void:
	GAME._set_cursor_in_select(true)
	_show_information()

func _on_element_mouse_exited(_button: TextureButton) -> void:
	GAME._set_cursor_in_select(false)
	_hide_information()

func _on_element_unlocked(element) -> void:
	if element.get("id") != el_id: return
	
	var element_to_unlock : int = GAME.unlocked[ element.get("id") ]
	var etui = GAME.get_elements()[element_to_unlock].get("id")
	var etun = GAME.get_elements()[element_to_unlock].get("name")
	
	var should_unlock_element : bool = GAME.unlocked[element_to_unlock]
	
	print("Element N°" + str(element_to_unlock) + " will be unlocked. Element details : [id] " + str(etui) + " | [name] " + etun + "...")
	set_button_disabled( not should_unlock_element )
