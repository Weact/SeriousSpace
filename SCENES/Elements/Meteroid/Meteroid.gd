extends SpaceElement
class_name Meteroid
func is_class(value: String): return value == "Meteroid" or .is_class(value)
func get_class() -> String: return "Meteroid"

#### ACCESSORS ####

#### BUILT-IN ####



#### VIRTUALS ####

func set_sprite_to_image_index() -> void:
	if not is_instance_valid(cd_sprite): return
	if not cd_sprite.is_region(): return
	cd_sprite.set_region_rect(Rect2(get_sprite_region_by_index(), 0, 32, 32))

#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
