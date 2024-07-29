extends Control

@export var race_timer: PackedScene

# don't forget to set minimum sizes for Score Box, otherwise shrinks when instantiated
@onready var margin_container: MarginContainer = $MarginContainer
@onready var score_box: HBoxContainer = $MarginContainer/ScoreBox
@onready var time_box: HBoxContainer = $MarginContainer/ScoreBox/TimeBox
@onready var minutes_label: Label = $MarginContainer/ScoreBox/TimeBox/MinutesLabel
@onready var seconds_label: Label = $MarginContainer/ScoreBox/TimeBox/SecondsLabel
@onready var milliseconds_label: Label = $MarginContainer/ScoreBox/TimeBox/MillisecondsLabel
@onready var player_1: HBoxContainer = $MarginContainer/ScoreBox/Player1
@onready var player_1_label: Label = $MarginContainer/ScoreBox/Player1/Player1Label
@onready var player_2: HBoxContainer = $MarginContainer/ScoreBox/Player2
@onready var player_2_label: Label = $MarginContainer/ScoreBox/Player2/Player2Label
@onready var pause_menu_layer: CanvasLayer = $PauseMenu/PauseMenuLayer
@onready var start_timer: Timer = $StartTimer


var score_player_1: int
var score_player_2: int
var total_minutes: int
var seconds: int # called 60 fps by physics process
var total_seconds: int
var miliseconds: float

## global vars includes
var total_laps: int

func _ready() -> void:
	pause_menu_layer.hide()
	SignalManager.connect("full_lap_update_score_player_1", update_score_label_p1)
	SignalManager.connect("full_lap_update_score_player_2", update_score_label_p2)
	
	if GlobalVars.total_players == 1:
		player_2.hide()
		
	if GlobalVars.lap_select > 0:
		total_laps = GlobalVars.lap_select
		
	start_timer.start()	
	get_tree().paused = true

		
func _physics_process(delta: float) -> void: # called 60 times a second

	seconds += 1
	miliseconds += 16.7
	
	milliseconds_label.text = "%03d" %miliseconds
	
	if miliseconds >= 1000:
		miliseconds = 0.00
	
	if total_seconds == 60:
		total_minutes += 1
		if total_minutes < 10:
			minutes_label.text = "0" + str(total_minutes) + ":"
		else:
			minutes_label.text = str(total_minutes) + ":"
		total_seconds = 0
	if seconds == 60:
		total_seconds += 1
		if total_seconds < 10:
			seconds_label.text = "0" + str(total_seconds) + ":"
		else:
			seconds_label.text = str(total_seconds) + ":"
		seconds = 0
	
func update_score_label_p1() -> void:
	score_player_1 += 1
	if score_player_1 == total_laps:
		pause_menu_layer.show()
		get_tree().paused = true
	player_1_label.text = "P1 LAPS: " + str(score_player_1)

func update_score_label_p2() -> void:
	score_player_2 += 1
	player_2_label.text = "P2 LAPS: " + str(score_player_2)

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_start_timer_timeout() -> void:
	await get_tree().create_timer(4.0).timeout
	get_tree().paused = false	
