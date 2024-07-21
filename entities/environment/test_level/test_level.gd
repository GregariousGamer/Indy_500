extends Node2D


@export var player_car: PackedScene

var new_car: CharacterBody2D

@onready var car_start_marker: Marker2D = $TileMaps/BaseMap/CarStartMarker


func _ready() -> void:
	new_car = player_car.instantiate()
	new_car.position = car_start_marker.position
	add_child(new_car)
