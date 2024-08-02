extends Node

var track_select: int
var total_players: int
var lap_select: int
var race_style: String
var points_tag_total: int

var player_one_glowing: bool = false
var player_two_glowing: bool = false

var point_box_deleted: bool = false

var player_cars_can_interact: bool = true

var slippy_physics: bool = false

var hud_start: bool = false

var main: String = "res://scenes/main/main.tscn"
var track_1: String = "res://scenes/levels/track_1.tscn"
var track_2: String = "res://scenes/levels/track_2.tscn"

