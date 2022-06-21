extends Node
func is_class(value: String): return value == "MergeHandler" or .is_class(value)
func get_class() -> String: return "MergeHandler"

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	if GAME.DEBUG:
		print("MergeHandler is ready")

func _physics_process(_delta: float) -> void:
	pass

#### VIRTUALS ####



#### LOGIC ####
func init() -> void:
	var __
	
	for draggable in GAME.get_draggables():
		__ = draggable.connect("element_dropped", self, "_on_element_dropped")
		
	if GAME.DEBUG:
		print("MergeHandler has been initialized")

func convert_mergeable_id(mergeable_element_id : int) -> int:
	match(mergeable_element_id):
		0:
			return 1
		1:
			return 2
		2:
			return 3
		3:
			return 4
		4:
			return 5
		_:
			return -1

func are_elements_compatibles(el_o : RigidBody2D, el_t : RigidBody2D) -> bool:
	"""
	Behavior : check if two elements are compatible for merge
	Returns : boolean
	"""
	
	if el_o.get_id() == 6 or el_t.get_id() == 6:
		return false
		
	"""
	If the origin or the target is a black hole :
		If the origin AND the target is a black hole :
			Unlock Black Hole if not Unlocked YET
			Spawn a random amount of eleent between 2 and 5 of element e in array GAME.ARRAY_BLACKHOLE_EXPLODE
			Destroy both Black Holes
			*** RETURN FALSE ***
			
		If the origin is a black hole, destroy the target
			*** RETURN FALSE ***
			
		If the target is a black hole, destroy the origin
			*** RETURN FALSE ***
	"""
	
	if el_o.get_id() == 5 or el_t.get_id() == 5:
		if el_o.get_id() == 5 and el_t.get_id() == 5:
			if not GAME.is_element_unlocked_by_id(5):
				GAME.unlock_element_by_id(5)
				
			var elo_p : Vector2 = el_o.get_global_position()
			var el_a : int = randi() % 5 + 2
			GAME.spawn_random_element(elo_p, el_a, GAME.ARRAY_BLACKHOLE_EXPLODE)
			el_o.call_deferred("queue_free")
			el_t.call_deferred("queue_free")
			return false
			
		if el_o.get_id() == 5:
			el_t.call_deferred("queue_free")
			return false
		elif el_t.get_id() == 5:
			el_o.call_deferred("queue_free")
			return false
	
	if el_o.get_id() == GAME.get_last_id():
		return false
	
	if el_o.get_id() == el_t.get_id():
		if el_o.get_id() < 5:
			GAME.unlock_element_by_id(el_o.get_id())
		return true
	
	
	return false

func merge(el_o : RigidBody2D, el_t : RigidBody2D) -> void:
	"""
	Behavior : Try to merge two elements, Destroy previous elements and instantiate merged element
	Returns : nothing
	"""
	
	var el_o_id = el_o.get_id()
	var el_o_position = el_o.get_global_position()
	var el_o_name = GAME.get_element_name_by_id(el_o_id)
	
	var merged_id : int = convert_mergeable_id(el_o_id)
	if merged_id == -1: return
	
	var merged_element_name : String = GAME.get_element_name_by_id(merged_id)
	var merged_element = GAME.get_element_scene_by_name(merged_element_name)
	
	if merged_element == null:
		push_error("MERGED ELEMENT IS NULL")
		return
	
	el_o.call_deferred("queue_free")
	el_t.call_deferred("queue_free")
	
	if GAME.DEBUG:
		print("ORIGIN ID : " + str(el_o_id) + " ORIGIN NAME : " + el_o_name +\
		" | MERGED ID : " + str(merged_id) + " MERGED NAME : "\
		 + merged_element_name + " MERGED ELEMENT SCENE : " +\
		 str(merged_element) + " MERGED ELEMENT SCENE NAME : " +\
		 merged_element.get_state().get_node_name(0))
	
	var merged_element_instance = merged_element.instance()
	
	if GAME.DEBUG:
		var parent_node = GAME.objects_container_nodes[merged_id].get_path()
		print("PARENT NODE : " + parent_node)
		merged_element_instance.set_global_position(el_o_position)
		merged_element_instance.connect("element_dropped", self, "_on_element_dropped")
		GAME.objects_container_nodes[merged_id].call_deferred("add_child", merged_element_instance, true)
		yield(merged_element_instance, "ready")
		merged_element_instance.play_appear()

#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_element_dropped(o : Area2D, t : Area2D) -> void:
	"""
	Origin : SpaceElement
	Target : Self
	Args : Area2Ds of elements overlapping (o:origin t:target)
	
	Goal : Check if the two overlapping elements are compatible to eachother
	Y : Merge them
	N : return
	"""
	
	var o_owner : RigidBody2D = null if not o else o.get_owner()
	var t_owner : RigidBody2D = null if not t else t.get_owner()
	
	if not o_owner and not t_owner: return
	
	if not o_owner:
		push_warning("origin element is invalid")
		
	if not t_owner:
		push_warning("target element is invalid")
	
	### MERGE OR RETURN BEHAVIOR
	if are_elements_compatibles(o_owner, t_owner):
		merge(o_owner, t_owner)
	else:
		if GAME.DEBUG:
			push_warning("Cannot merge incompatible elements : " + o_owner.get_name() + " with " + t_owner.get_name())
		return
