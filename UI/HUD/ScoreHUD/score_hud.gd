extends Control

# don't forget to set minimum sizes for Score Box, otherwise shrinks when instantiated
@onready var margin_container: MarginContainer = $MarginContainer
@onready var score_box: HBoxContainer = $MarginContainer/ScoreBox
@onready var time_box: HBoxContainer = $MarginContainer/ScoreBox/TimeBox
@onready var time_label: Label = $MarginContainer/ScoreBox/TimeBox/TimeLabel
@onready var player_1: HBoxContainer = $MarginContainer/ScoreBox/Player1
@onready var player_1_label: Label = $MarginContainer/ScoreBox/Player1/Player1Label
@onready var player_2: HBoxContainer = $MarginContainer/ScoreBox/Player2
@onready var player_2_label: Label = $MarginContainer/ScoreBox/Player2/Player2Label

var score_player_1: int
var score_player_2: int

func _ready() -> void:
	SignalManager.connect("full_lap_update_score_player_1", update_score_label_p1)
	SignalManager.connect("full_lap_update_score_player_2", update_score_label_p2)
	
func update_score_label_p1() -> void:
	score_player_1 += 1
	player_1_label.text = "P1 LAPS: " + str(score_player_1)

func update_score_label_p2() -> void:
	score_player_2 += 1
	player_2_label.text = "P2 LAPS: " + str(score_player_2)

