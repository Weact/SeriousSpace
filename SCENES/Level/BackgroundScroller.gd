extends ParallaxBackground
const scrolling_speed : float = 5.0
func _physics_process(delta: float) -> void:
	scroll_offset += Vector2(scrolling_speed * delta, scrolling_speed * delta)
