extends Node2D

@export var player_car: PackedScene
@export var score_hud: PackedScene

var new_car: CharacterBody2D
var total_lap_complete: Array[int] = [1, 2, 3]
var player_checkpoint_tracker: Array[int]
var player_lap_tracker: int

var new_hud: Control

@onready var car_start_marker: Marker2D = $Player/CarStartMarker
@onready var lap_sound: AudioStreamPlayer2D = $Sounds/lap_sound

func _ready() -> void:
	new_car = player_car.instantiate()
	new_car.position = car_start_marker.position
	new_car.add_to_group("player_1")
	add_child(new_car)
	
	new_hud = score_hud.instantiate()
	new_hud.position = Vector2(0, -325) # moved up because track is not centered on viewport
	add_child(new_hud)
	
# laps logic
func _on_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		if player_checkpoint_tracker == total_lap_complete:
			player_lap_tracker += 1
			lap_sound.play()
			if body.is_in_group("player_1"):
				SignalManager.full_lap_update_score_player_1.emit()
			else:
				SignalManager.full_lap_update_score_player_2.emit()
		player_checkpoint_tracker.clear()

func _on_one_body_entered(body: Node2D) -> void:
	if (body.is_in_group("car")
	&& !player_checkpoint_tracker.has(1)):
		player_checkpoint_tracker.append(1)

func _on_two_body_entered(body: Node2D) -> void:
	if (body.is_in_group("car")
	&& !player_checkpoint_tracker.has(2)):
		player_checkpoint_tracker.append(2)

func _on_three_body_entered(body: Node2D) -> void:
	if (body.is_in_group("car")
	&& !player_checkpoint_tracker.has(3)):
		player_checkpoint_tracker.append(3)
