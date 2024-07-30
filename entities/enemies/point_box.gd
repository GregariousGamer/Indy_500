extends Sprite2D

func _ready() -> void:
	
	if GlobalVars.track_select == 1:
		var random_quadrant: int = randi_range(0, 3)
		var spawn_location_x: int
		var spawn_location_y: int
		
		if random_quadrant == 0:
			spawn_location_x = randi_range(-620, -420)
			spawn_location_y = randi_range(-250, 250)
		elif random_quadrant == 1:
			spawn_location_x = randi_range(-270, 270)
			spawn_location_y = randi_range(-155, -65)
		elif random_quadrant == 2:
			spawn_location_x = randi_range(400, 615)
			spawn_location_y = randi_range(-245, 245)
		elif random_quadrant == 3:
			spawn_location_x = randi_range(-270, 270)
			spawn_location_y = randi_range(75, 165)
	
	
		self.position = Vector2(spawn_location_x, spawn_location_y)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):

		if body.is_in_group("player_1"):
			SignalManager.player_1_point.emit()
		if body.is_in_group("player_2"):
			SignalManager.player_2_point.emit()
			
	SignalManager.can_spawn_point.emit()
	queue_free()
