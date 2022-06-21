extends Control
class_name ObjectiveWindow
func is_class(value: String):return value == "ObjectiveWindow" or .is_class(value)
func get_class() -> String:return "ObjectiveWindow"

onready var wt : Tween = get_node("WindowTransition")
onready var objectivespanel : Panel = get_node("CanvasLayer/Objectives")

export(float) var objective_offset_x = -225.0

enum STATE {CLOSE = -1, OPEN = 1}
export(int) var ostate = STATE.OPEN

#### ACCESSORS ####

#### BUILT-IN ####

func _ready() -> void:
	pass

#### LOGIC ####

func switch_window() -> void:
	if not is_instance_valid(objectivespanel):
		push_warning("Invalid Objective Panel")
		return
		
	var fstate : int = ostate * -1
	ostate = STATE.OPEN if fstate == 1 else STATE.CLOSE
	
	if ostate == STATE.OPEN:
		$CanvasLayer/Objectives/HideButton.set_text(">")
	elif ostate == STATE.CLOSE:
		$CanvasLayer/Objectives/HideButton.set_text("<")
	
	wt.interpolate_property(
		objectivespanel,
		"rect_position:x",
		objectivespanel.get_global_position().x,
		objectivespanel.get_global_position().x + (objective_offset_x * ostate), 1.0,
		Tween.TRANS_SINE,
		Tween.EASE_IN
		)
	wt.start()

#### VIRTUALS ####

#### INPUTS ####

#### SIGNAL RESPONSES ####


func _on_HideButton_button_down() -> void:
	switch_window()
