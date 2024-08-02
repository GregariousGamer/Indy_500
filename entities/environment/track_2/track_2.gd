extends Node2D

@export var score_hud: PackedScene
@export var player_car: PackedScene
@export var player2_car: PackedScene
@export var race_start_sound: PackedScene
@export var point_box: PackedScene

var new_car: CharacterBody2D
var new_car_2: CharacterBody2D

var new_hud: Control

@onready var car_start_marker: Marker2D = $Player/CarStartMarker
@onready var car_2_start_marker: Marker2D = $Player/Car2StartMarker


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
	
	var new_race_start = race_start_sound.instantiate()
	add_child(new_race_start)

