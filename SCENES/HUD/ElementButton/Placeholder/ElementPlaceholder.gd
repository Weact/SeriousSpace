extends TextureRect
class_name ElementPlaceholder
func is_class(value: String): return value == "ElementPlaceholder" or .is_class(value)
func get_class() -> String: return "ElementPlaceholder"

var el_id : int = -1
var el_name : String = ""
var el_pre : Texture = null

var r : bool = false

#### ACCESSORS ####

func set_button_name(n : String) -> void:
	el_name = n
	set_name(el_name)
func get_element_name() -> String:
	return el_name

func set_id(i: int) -> void:
	el_id = i
func get_element_id() -> int:
	return el_id

func set_pre(p: Texture) -> void:
	el_pre = p
	set_texture(el_pre)
func get_element_pre() -> Texture:
	return el_pre

#### BUILT-IN ####

func _physics_process(_delta: float) -> void:
	if r:
		move()

func _ready() -> void:
	set_physics_process(false)

func _setup() -> void:
	r = true
	set_physics_process(true)

func _destroy() -> void:
	r = false
	set_physics_process(false)
	_create_element(el_id)
	call_deferred("queue_free")

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	if event.button_index == BUTTON_LEFT and not event.pressed:
		_destroy()

#### VIRTUALS ####

#### LOGIC ####

func move() -> void:
	set_global_position(get_global_mouse_position())

func _init_placeholder_values(e_id: int, e_name: String, e_pre: Texture) -> void:
	var prefix : String = "_Placeholder"
	set_id(e_id)
	set_button_name(e_name + prefix)
	set_pre(e_pre)

func _create_element(e_id: int) -> void:
	GAME.force_spawn_element(e_id)

#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_placeholder_dropped() -> void:
	_destroy()
