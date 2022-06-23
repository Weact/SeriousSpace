extends Control
class_name ObjectiveWindow
func is_class(value: String):return value == "ObjectiveWindow" or .is_class(value)
func get_class() -> String:return "ObjectiveWindow"

onready var wt : Tween = get_node("WindowTransition")
onready var opt : Tween = get_node("ObjectiveProgressTransition")
onready var at : Tween = get_node("AchievementTransition")

onready var Objectivespanel : Panel = get_node("CanvasLayer/Objectives")
onready var ObjectivesContainer : VBoxContainer = Objectivespanel.get_node("ObjectivesContainer")
onready var ObjectiveTitle : Label = ObjectivesContainer.get_node("ObjectiveTitle")
onready var ObjectiveDescription : Label = ObjectivesContainer.get_node("ObjectiveDescription")
onready var ObjectiveProgress : Label = ObjectivesContainer.get_node("ObjectiveProgress")

onready var Achievementpanel : Panel = get_node("CanvasLayer/Achievements")
onready var AchievementTitle : Label = Achievementpanel.get_node("WindowTitle")
onready var AchievementDescr : Label = Achievementpanel.get_node("WindowDescr")

onready var ap_ip : Vector2 = Achievementpanel.get_global_position()
onready var ap_fp : Vector2 = Vector2(ap_ip.x, ap_ip.y + 320)

export(float) var objective_offset_x = -225.0

enum STATE {CLOSE = -1, OPEN = 1}
export(int) var ostate = STATE.OPEN

enum ASTATE {CLOSE = -1, OPEN = 1}
export(int) var astate = ASTATE.CLOSE


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

func display_achievement(at : String, ad : String) -> void:
	AchievementTitle.set_text(at)
	AchievementDescr.set_text(ad)
	play_achievement_tween()

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
	var op_complete = ""
	
	if objective_id == 7:
		var t_dm : String = "Matière Noire " + str(GAME.GALAXY_CURRENT_PROGRESS[0]) + "/" + str(GAME.GALAXY_TARGET_PROGRESS[0]) + "\n"
		var t_cd : String = "Poussière Cosmique " + str(GAME.GALAXY_CURRENT_PROGRESS[1]) + "/" + str(GAME.GALAXY_TARGET_PROGRESS[1]) + "\n"
		var t_m : String = "Météoroïde " + str(GAME.GALAXY_CURRENT_PROGRESS[2]) + "/" + str(GAME.GALAXY_TARGET_PROGRESS[2]) + "\n"
		var t_p : String = "Planète " + str(GAME.GALAXY_CURRENT_PROGRESS[3]) + "/" + str(GAME.GALAXY_TARGET_PROGRESS[3]) + "\n"
		var t_s : String = "Etoile " + str(GAME.GALAXY_CURRENT_PROGRESS[4]) + "/" + str(GAME.GALAXY_TARGET_PROGRESS[4]) + "\n"
		var t_bh : String = "Trou Noir " + str(GAME.GALAXY_CURRENT_PROGRESS[5]) + "/" + str(GAME.GALAXY_TARGET_PROGRESS[5]) + "\n"
		
		op_body = op_body + t_dm + t_cd + t_m + t_p + t_s + t_bh
		op_complete = op_head + op_body
	else:
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

func play_achievement_tween() -> void:
	var __
	__ = at.interpolate_property(
		Achievementpanel,
		"rect_position:y",
		ap_ip.y,
		ap_fp.y, 2.0,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	at.start()
	yield(at, "tween_completed")
	yield(get_tree().create_timer(5.0), "timeout")
	close_achievement_panel()

func close_achievement_panel() -> void:
	var __
	__ = at.interpolate_property(
		Achievementpanel,
		"rect_position:y",
		ap_fp.y,
		ap_ip.y, 2.0,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	at.start()

func play_progress_tween() -> void:
	var __
	__ = opt.interpolate_property(
		ObjectiveProgress,
		"rect_scale",
		ObjectiveProgress.get_scale(),
		Vector2(1.3, 1.3), 1.0,
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
		Vector2(1.0, 1.0), 1.0,
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

func _on_current_progress_changed(objective_id, _progress) -> void:
	if objective_id != GAME.current_objective: return
	display_objective(objective_id)

func _on_objective_completed(objective, next_objective) -> void:
	display_objective(next_objective.get("id"))
	display_achievement(GAME.get_objective_frname_by_id(objective.get("id")), GAME.get_objective_fr_success_descr_by_id(objective.get("id")))

func _on_HideButton_button_down() -> void:
	switch_window()
