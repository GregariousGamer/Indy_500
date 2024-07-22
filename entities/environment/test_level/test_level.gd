extends Node2D

# bridge collision layer / mask == 1 ; bridge z index == 1
# tunnel collision layer / mask == 2; tunnel z index == 0
# car z index == -1

@export var player_car: PackedScene

var new_car: CharacterBody2D
var total_lap_complete: Array[int] = [1, 2, 3]
var player_checkpoint_tracker: Array[int]
var player_lap_tracker: int

@onready var car_start_marker: Marker2D = $TileMaps/BaseMap/CarStartMarker

func _ready() -> void:
	new_car = player_car.instantiate()
	new_car.position = car_start_marker.position
	add_child(new_car)

# car enters tunnel and z index moved down 1
# to be below the tunnel layer
# turns correct collision on for tunnel and disables bridge
func _on_tunnel_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		body.z_index = -1
		body.set_collision_mask_value(1, false)
		body.set_collision_mask_value(2, true)
	
# car enters bridge and z index == 2 (above bridge)
# to be above the bridge layer
# turns correct collision on for bridge and disables tunnel
func _on_bridge_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		body.z_index = 2
		body.set_collision_mask_value(2, false)
		body.set_collision_mask_value(1, true)

# sets of functions that have checkpoints to tell if you are going the right direction
func _on_start_point_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		if player_checkpoint_tracker == total_lap_complete:
			player_lap_tracker += 1
			print(player_lap_tracker)
		player_checkpoint_tracker.clear()

func _on_checkpoint_1_body_entered(body: Node2D) -> void:
	if (body.is_in_group("car")
	&& !player_checkpoint_tracker.has(1)):
		player_checkpoint_tracker.append(1)

func _on_check_point_2_body_entered(body: Node2D) -> void:
	if (body.is_in_group("car")
	&& !player_checkpoint_tracker.has(2)):
		player_checkpoint_tracker.append(2)

func _on_check_psoint_3_body_entered(body: Node2D) -> void:
	if (body.is_in_group("car")
	&& !player_checkpoint_tracker.has(3)):
		player_checkpoint_tracker.append(3)
