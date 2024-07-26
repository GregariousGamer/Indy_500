extends Node2D



func _on_select_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/track_1.tscn")
