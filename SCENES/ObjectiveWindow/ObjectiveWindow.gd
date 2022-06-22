extends Control
class_name ObjectiveWindow
func is_class(value: String):return value == "ObjectiveWindow" or .is_class(value)
func get_class() -> String:return "ObjectiveWindow"

onready var wt : Tween = get_node("WindowTransition")
onready var opt : Tween = get_node("ObjectiveProgressTransition")

onready var Objectivespanel : Panel = get_node("CanvasLayer/Objectives")
onready var ObjectivesContainer : VBoxContainer = Objectivespanel.get_node("ObjectivesContainer")
onready var ObjectiveTitle : Label = ObjectivesContainer.get_node("ObjectiveTitle")
onready var ObjectiveDescription : Label = ObjectivesContainer.get_node("ObjectiveDescription")
onready var ObjectiveProgress : Label = ObjectivesContainer.get_node("ObjectiveProgress")

export(float) var objective_offset_x = -225.0

enum STATE {CLOSE = -1, OPEN = 1}
export(int) var ostate = STATE.OPEN


#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	var __
	__ = GAME.connect("current_progress_changed", self, "_on_current_progress_changed")
	__ = GAME.connect("objective_completed", self, "_on_objective_completed")
	
	init_objectives()

#### LOGIC ####

func switch_window() -> void:
	if not is_instance_valid(Objectivespanel):
		push_warning("Invalid Objective Panel")
		return
		
	var fstate : int = ostate * -1
	ostate = STATE.OPEN if fstate == 1 else STATE.CLOSE
	
	if ostate == STATE.OPEN:
		$CanvasLayer/Objectives/HideButton.set_text(">")
	elif ostate == STATE.CLOSE:
		$CanvasLayer/Objectives/HideButton.set_text("<")
	
	var __
	__ = wt.interpolate_property(
		Objectivespanel,
		"rect_position:x",
		Objectivespanel.get_global_position().x,
		Objectivespanel.get_global_position().x + (objective_offset_x * ostate), 1.0,
		Tween.TRANS_SINE,
		Tween.EASE_IN
		)
	__ = wt.start()

func display_objective(objective_id : int) -> void:
	var oi : int = objective_id
	var o_t : String = GAME.get_objective_frname_by_id(oi)
	var o_d : String = GAME.get_objective_frdescr_by_id(oi)
	var o_cp : Array = GAME.get_objective_current_progress_by_id(oi)
	var o_tp : Array = GAME.get_objective_target_progress_by_id(oi)
	
	var op_complete : String = format_op_complete(oi, o_cp, o_tp)
	
	if op_complete == "":
		push_error("Objective Progress Complete value is null")
		return
	
	ObjectiveTitle.set_text( o_t )
	ObjectiveDescription.set_text(o_d)
	change_objective_progress(op_complete)

func format_op_complete(objective_id : int, objective_current_progress : Array, objective_target_progress : Array) -> String:
	"""
	Returns the complete formated string for the progress text
	We need to count the size of the target progress array to know if there are
		one or more objectives to complete
	According to the size, the returned string will be different
	"""
	var objective_progress : Dictionary = GAME.get_objective_progress_dictionary_by_id(objective_id)
	
	var op_head : String = "PROGRESS :\n"
	var op_body : String = ""
	
	var op_complete : String = ""
	
	if objective_target_progress.size() == 1:
		op_body = str( objective_current_progress[0] ) + "/" + str( objective_target_progress[0] )
	else:
		if objective_progress == {}:
			push_error("Target objective progress with id " + str(objective_id) + " with name " + GAME.get_objective_frname_by_id(objective_id) + " is empty")
			return ""
			
		var cp_d : String = ""
		for progress in objective_progress:
			var ocp : String = ""
			for p in objective_current_progress:
				ocp = str(objective_current_progress[p])
			cp_d = progress + " " + ocp + "/" + objective_progress[progress]
			op_body = op_body + cp_d + "\n"
	
	op_complete = op_head + op_body if ( op_head != "" and op_body != "" ) else ""
	return op_complete if op_complete != "" else ""

func change_objective_progress(op_complete : String) -> void:
	ObjectiveProgress.set_text( op_complete )
	play_progress_tween()

func init_objectives() -> void:
	display_objective(0)
	
func play_progress_tween() -> void:
	var __
	__ = opt.interpolate_property(
		ObjectiveProgress,
		"rect_scale",
		ObjectiveProgress.get_scale(),
		ObjectiveProgress.get_scale() * 1.3, 1.0,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT
		)
	__ = opt.interpolate_property(
		ObjectiveProgress,
		"self_modulate",
		ObjectiveProgress.get_self_modulate(),
		Color(1.0, 1.0, 1.0, 1.0), 1.0,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT
	)
	
	__ = opt.start()
	
	yield(opt, "tween_completed")
	
	__ = opt.interpolate_property(
		ObjectiveProgress,
		"rect_scale",
		ObjectiveProgress.get_scale(),
		ObjectiveProgress.get_scale() / 1.3, 1.0,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT
		)
	__ = opt.interpolate_property(
		ObjectiveProgress,
		"self_modulate",
		ObjectiveProgress.get_self_modulate(),
		Color(0.99, 1.0, 0.0, 1.0), 1.0,
		Tween.TRANS_BACK,
		Tween.EASE_IN_OUT
	)
	
	__ = opt.start()

#### VIRTUALS ####

#### INPUTS ####

#### SIGNAL RESPONSES ####

func _on_current_progress_changed(objective, _progress) -> void:
	display_objective(objective.get("id"))

func _on_objective_completed(_objective, next_objective) -> void:
	display_objective(next_objective.get("id"))

func _on_HideButton_button_down() -> void:
	switch_window()
