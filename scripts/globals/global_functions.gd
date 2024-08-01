extends Node


func cars_can_interact() -> void:
	await get_tree().create_timer(1.5).timeout
	GlobalVars.player_cars_can_interact = true
