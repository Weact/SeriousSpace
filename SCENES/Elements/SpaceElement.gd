extends RigidBody2D
class_name SpaceElement
func is_class(value: String): return value == "SpaceElement" or .is_class(value)
func get_class() -> String: return "SpaceElement"

## SIGNALS
signal selected_changed
signal element_dropped(origin, target)

## NODES
onready var cd_sprite := get_node_or_null("ElementSprite") if get_child(0) is Sprite else get_node_or_null("AElementSprite")
onready var area : Area2D = get_node_or_null("Area2D")
onready var area_collision : CollisionShape2D = area.get_node_or_null("CollisionShape2D")

## VARS
onready var zindex_init = get_z_index()
var zindex_current = get_z_index() setget set_zindex, get_zindex

export(int) var element_id = 0

export(int, 1, 4, 1) var image_index = 1

export var image_representation : Texture

export var element_scale_random_min : float = 1.0
export var element_scale_random_max : float = 5.0
export(float, 1.0, 5.0, 0.1) var element_scale_init = 1.0

export var enable_custom_scale : bool = false
export var random_scale_enabled : bool = false

export var random_modulate_enabled : bool = false

var space_description : String = ""

### APPEARTWEEN
var i_scale : Vector2
var f_scale : Vector2
var i_modulate : Color
var f_modulate : Color

var selected : bool = false

var next_element : PhysicsBody2D = null

#### ACCESSORS ####

## ZINDEX

func set_zindex(new_zi : int) -> void:
	if new_zi != zindex_current:
		zindex_current = new_zi
		set_z_index(new_zi)

func reset_zindex() -> void:
	set_zindex(zindex_init)

func get_zindex() -> int:
	return zindex_current

## ID
func get_id() -> int:
	return element_id

## IMAGE INDEX
func get_image_index() -> int:
	return image_index

func set_image_index(v: int) -> void:
	if not v in [1, 2, 3, 4]: return
	image_index = v

func set_sprite_to_image_index() -> void:
	if not is_instance_valid(cd_sprite): return
	if not cd_sprite.is_region(): return
	cd_sprite.set_region_rect(Rect2(randi() % 96 + 1, 0, 32, 32))

func init_image_index_to_sprite() -> void:
	randomize()
	set_image_index(randi() % 4 + 1)
	set_sprite_to_image_index()

func get_sprite_region_by_index() -> int:
	match(image_index):
		0:
			return 0
		1:
			return 32
		2:
			return 64
		3:
			return 96
		_:
			return 0

## DESCR

func set_descr() -> void:
	space_description = GAME.get_element_sdescr_by_id(element_id)

func get_descr() -> String:
	return space_description

### REP SPRITE

func get_rep_sprite() -> Texture:
	return image_representation

### PROPERTY INIT

func init_scale() -> void:
	if random_scale_enabled:
		randomize()
		element_scale_init = round(rand_range(element_scale_random_min, element_scale_random_max))
	cd_sprite.set_scale( Vector2( element_scale_init, element_scale_init ) )
	area_collision.set_scale( Vector2( element_scale_init, element_scale_init) )

func init_random_modulate() -> void:
	if random_modulate_enabled:
		randomize()
		var r = rand_range(0.1, 1.0)
		var g = rand_range(0.1, 1.0)
		var b = rand_range(0.1, 1.0)
		cd_sprite.set_modulate( Color(r, g, b, 1.0) )

## SELECTED
func is_selected() -> bool:
	return selected

func set_selected(select : bool) -> void:
	if selected == select: return
	
	if select and GAME.is_draggable_already_selected_in_group():
		return
		
	selected = select
	emit_signal("selected_changed")

#### BUILT-IN ####

func _ready() -> void:
	var __
	
	if cd_sprite is Sprite:
		init_image_index_to_sprite()
	
	init_scale()
	init_random_modulate()
	set_descr()
	
	__ = connect("selected_changed", self, "_on_selected_changed")
	__ = area.connect("area_entered", self, "_on_area_entered")
	__ = area.connect("area_exited", self, "_on_area_exited")

	print("ELEMENT " + get_name() + " HAS SPRITE : " + str(get_child(0) is Sprite) + "; HAS ANIM SPRITE : " + str( get_child(0) is AnimatedSprite ) )
	
func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and selected:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			set_selected(false)

#### VIRTUALS ####

#### LOGIC ####

func play_appear() -> void:
	init_tween_vars()
	$AppearTween.interpolate_property(self, "scale", i_scale, f_scale, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$AppearTween.interpolate_property(self, "modulate", i_modulate, f_modulate, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$AppearTween.interpolate_property(self, "scale", f_scale, i_scale, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$AppearTween.interpolate_property(self, "modulate", f_modulate, i_modulate, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$AppearTween.start()

func init_tween_vars() -> void:
	i_scale = get_scale()
	f_scale = get_scale() * 2
	
	i_modulate = get_modulate()
	f_modulate = Color(0.3, 0.3, 0.3, 0.75)

func handle_signals() -> void:
	var __
	
	if selected:
		if area.is_connected("area_entered", self, "_on_area_entered") and\
		area.is_connected("area_exited", self, "_on_area_exited"):
			
			area.disconnect("area_entered", self, "_on_area_entered")
			area.disconnect("area_exited", self, "_on_area_exited")
	else:
		if not area.is_connected("area_entered", self, "_on_area_entered") and\
		not area.is_connected("area_exited", self, "_on_area_exited"):
			
			__ = area.connect("area_entered", self, "_on_area_entered")
			__ = area.connect("area_exited", self, "_on_area_exited")

func _are_areas_overlapping() -> bool:
	if area.get_overlapping_areas().size() > 0:
		return true
	return false

func _get_first_overlapping_area() -> Area2D:
	if not _are_areas_overlapping(): return null
	return area.get_overlapping_areas()[0]

#### INPUTS ####

#### SIGNAL RESPONSES ####

func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not event is InputEventMouseButton: return
	if Input.is_action_just_pressed("click"):
		set_selected(true)

func _on_area_entered(a: Area2D) -> void:
	if not a or a.owner.is_selected(): return
	
	if GAME.DEBUG:
		print(a.owner.get_name() + " has entered " + get_name())

func _on_area_exited(a: Area2D) -> void:
	if not a or not a.owner:
		return
	if a.owner.is_selected():
		return
	
	if GAME.DEBUG:
		print(a.owner.get_name() + " has exited " + get_name())

func _on_selected_changed() -> void:
	if selected:
		set_zindex(999)
	else:
		reset_zindex()
	handle_signals()
	if not selected and _are_areas_overlapping():
		emit_signal("element_dropped", area, _get_first_overlapping_area())
		
		if GAME.DEBUG:
			print("One overlapping area has been found ! " + _get_first_overlapping_area().get_owner().get_name() + " has been emitted with our own area from origin " + get_name())
