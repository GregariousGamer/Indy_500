extends Node2D

@export var player_car: PackedScene
@export var player2_car: PackedScene
@export var score_hud: PackedScene
@export var race_start_sound: PackedScene
@export var point_box: PackedScene

var new_car: CharacterBody2D
var new_car_2: CharacterBody2D
var total_lap_complete: Array[int] = [1, 2, 3]

var player_checkpoint_tracker: Array[int]
var player_checkpoint_tracker_2: Array[int]

var player_lap_tracker: int
var player_lap_tracker_2: int

var new_hud: Control

var new_point_box: Sprite2D
var can_spawn_point_box: bool = true


@onready var car_start_marker: Marker2D = $Player/CarStartMarker
@onready var car_2_start_marker: Marker2D = $Player/Car2StartMarker
@onready var lap_sound: AudioStreamPlayer2D = $Sounds/lap_sound


func _ready() -> void:
	
	new_car = player_car.instantiate()
	new_car.position = car_start_marker.position
	new_car.add_to_group("player_1")
	add_child(new_car)
	
	if GlobalVars.total_players == 2:
		new_car_2 = player2_car.instantiate()
		new_car_2.position = car_2_start_marker.position
		new_car_2.add_to_group("player_2")
		add_child(new_car_2)
	
	new_hud = score_hud.instantiate()
	new_hud.position = Vector2(0, -325) # moved up because track is not centered on viewport
	add_child(new_hud)
	
	if GlobalVars.race_style == "POINTS":
		new_point_box = point_box.instantiate()
		new_point_box.position = Vector2(-650, -150)
		add_child(new_point_box)
		
	var new_race_start = race_start_sound.instantiate()
	add_child(new_race_start)
	
	
# laps logic
func _on_start_body_entered(body: Node2D) -> void:
	if GlobalVars.race_style == "RACE":
		if body.is_in_group("car"):
			if body.is_in_group("player_1"):
				if player_checkpoint_tracker == total_lap_complete:
					player_lap_tracker += 1
					lap_sound.play()
					SignalManager.full_lap_update_score_player_1.emit()
				player_checkpoint_tracker.clear()
			if body.is_in_group("player_2"):
				if player_checkpoint_tracker_2 == total_lap_complete:
					player_lap_tracker_2 += 1
					lap_sound.play()
					SignalManager.full_lap_update_score_player_2.emit()
				player_checkpoint_tracker_2.clear()

func _on_one_body_entered(body: Node2D) -> void:
	if GlobalVars.race_style == "RACE":
		if (body.is_in_group("player_1")
		&& !player_checkpoint_tracker.has(1)):
			player_checkpoint_tracker.append(1)
		if (body.is_in_group("player_2")
		&& !player_checkpoint_tracker_2.has(1)):
			player_checkpoint_tracker_2.append(1)
			
func _on_two_body_entered(body: Node2D) -> void:
	if GlobalVars.race_style == "RACE":
		if (body.is_in_group("player_1")
		&& !player_checkpoint_tracker.has(2)):
			player_checkpoint_tracker.append(2)
		if (body.is_in_group("player_2")
		&& !player_checkpoint_tracker_2.has(2)):
			player_checkpoint_tracker_2.append(2)

func _on_three_body_entered(body: Node2D) -> void:
	if GlobalVars.race_style == "RACE":
		if (body.is_in_group("player_1")
		&& !player_checkpoint_tracker.has(3)):
			player_checkpoint_tracker.append(3)
		if (body.is_in_group("player_2")
		&& !player_checkpoint_tracker_2.has(3)):
			player_checkpoint_tracker_2.append(3)
			
# points logic
func player_1_add_point() -> void:
	pass

func player_2_add_point() -> void:
	pass
