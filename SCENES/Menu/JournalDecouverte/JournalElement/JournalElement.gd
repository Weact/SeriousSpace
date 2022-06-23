extends ElementPlaceholder
class_name JournalElement
func is_class(value: String):return value == "JournalElement" or .is_class(value)
func get_class() -> String:return "JournalElement"

var unlocked : bool = false

#### ACCESSORS ####

func is_journal_element_unlocked() -> bool:
	return unlocked

#### BUILT-IN ####

func _setup() -> void:
	if is_instance_valid(get_owner()):
		var __
		__ = connect("mouse_entered", get_owner(), "_on_journal_element_mouse_entered", [self])
		__ = connect("mouse_exited", get_owner(), "_on_journal_element_mouse_exited", [self])
	else:
		push_error(get_name() + " does not have a valid owner to connect signals : mouse_entered and mouse_exited")

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	pass

func _destroy() -> void:
	pass

#### LOGIC ####

#### VIRTUALS ####

func move() -> void:
	pass

func _init_placeholder_values(e_id: int, e_name: String, e_pre: Texture) -> void:
	var prefix : String = "_Journal"
	set_id(e_id)
	set_button_name(e_name + prefix)
	set_pre(e_pre)
	
	"""
	Check for unlocked elements
	If not unlocked, disable it
	"""
	if not GAME.is_element_unlocked_by_id(e_id):
		set_self_modulate(GAME.DISABLED_ELEMENT_COLOR)
		unlocked = false
	else:
		set_self_modulate(GAME.ENABLED_ELEMENT_COLOR)
		unlocked = true

func _create_element(_e_id: int) -> void:
	pass

#### INPUTS ####

#### SIGNAL RESPONSES ####
