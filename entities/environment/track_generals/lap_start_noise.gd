extends Node2D

@onready var race_start_sound: AudioStreamPlayer2D = $RaceStartSound
@onready var timer: Timer = $Timer

# plays lap start sounds three times, elevating pitch on last play
func _on_timer_timeout() -> void:
	race_start_sound.play()
	await get_tree().create_timer(1.7).timeout
	race_start_sound.play()
	await get_tree().create_timer(1.7).timeout
	race_start_sound.pitch_scale *= 1.5
	race_start_sound.play()
