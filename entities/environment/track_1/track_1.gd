extends Node2D

@export var player_car: PackedScene

var new_car: CharacterBody2D
var total_lap_complete: Array[int] = [1, 2, 3]
var player_checkpoint_tracker: Array[int]
var player_lap_tracker: int

@onready var car_start_marker: Marker2D = $Player/CarStartMarker

func _ready() -> void:
	new_car = player_car.instantiate()
	new_car.position = car_start_marker.position
	add_child(new_car)

# laps logic
func _on_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		if player_checkpoint_tracker == total_lap_complete:
			player_lap_tracker += 1
			print(player_lap_tracker)
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
