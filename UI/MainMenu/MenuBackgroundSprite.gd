extends Sprite2D
 
func _process(delta: float) -> void:
	position += (get_global_mouse_position()*delta) - position + Vector2(-100, -100)
