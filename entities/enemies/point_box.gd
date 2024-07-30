extends Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		if body.is_in_group("player_1"):
			SignalManager.player_1_point.emit()
		if body.is_in_group("player_2"):
			SignalManager.player_2_point.emit()
			
	queue_free()
