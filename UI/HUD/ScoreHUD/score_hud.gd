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
@onready var retry_button: Button = $PauseMenu/PauseMenuLayer/PauseMenuBox/RetryButton
@onready var resume_button: Button = $PauseMenu/PauseMenuLayer/PauseMenuBox/ResumeButton
@onready var pause_label: Label = $PauseMenu/PauseMenuLayer/PauseMenuBox/PauseLabel


var score_player_1: int
var score_player_2: int
var total_minutes: int
var seconds: int # called 60 fps by physics process
var total_seconds: int
var miliseconds: float

## global vars includes
var total_laps: int

func _ready() -> void:
	SignalManager.connect("player_1_point", update_score_label_p1)
	SignalManager.connect("player_2_point", update_score_label_p2)
	
	pause_menu_layer.hide()
	SignalManager.connect("full_lap_update_score_player_1", update_score_label_p1)
	SignalManager.connect("full_lap_update_score_player_2", update_score_label_p2)
	
	if GlobalVars.race_style == "RACE":
		player_1_label.text = "P1 LAPS:"
		player_2_label.text = "P2 LAPS:"
		
	elif GlobalVars.race_style == "POINTS" || GlobalVars.race_style == "TAG":
		player_1_label.text = "P1 POINTS:"
		player_2_label.text = "P2 POINTS:"
	
	if GlobalVars.total_players == 1:
		player_2.hide()
		
	if GlobalVars.lap_select > 0:
		total_laps = GlobalVars.lap_select # determines when race is over
	if GlobalVars.points_tag_total > 0:
		total_laps = GlobalVars.points_tag_total
		
	start_timer.start()	
	get_tree().paused = true

		
func _physics_process(delta: float) -> void: # called 60 times a second

	if Input.is_action_pressed("escape"):
		if get_tree().paused == false:
			get_tree().paused = true
			pause_menu_layer.show()
			resume_button.show()

	if GlobalVars.race_style == "RACE":
		race_timer_time_clock()


## updates scores for players and brings up pause menu when lap score achieved	
func update_score_label_p1() -> void:
	if GlobalVars.race_style == "RACE":
		score_player_1 += 1
		if score_player_1 == total_laps:
			if GlobalVars.total_players == 2:
				pause_label.text = "PLAYER 1 WINS!!!"
			else:
				pause_label.text = str(total_laps) + " laps: " + minutes_label.text + seconds_label.text + milliseconds_label.text
			pause_menu_layer.show()
			retry_button.show()
			resume_button.hide()
			get_tree().paused = true
		player_1_label.text = "P1 LAPS: " + str(score_player_1)
		
	if GlobalVars.race_style == "POINTS":
		score_player_1 += 1
		if score_player_1 == GlobalVars.points_tag_total:
			pause_label.text = "PLAYER 1 WINS!!!"
			pause_menu_layer.show()
			retry_button.show()
			resume_button.hide()
			get_tree().paused = true
		player_1_label.text = "P1 POINTS: " + str(score_player_1)	

func update_score_label_p2() -> void:
	if GlobalVars.race_style == "RACE":
		score_player_2 += 1
		if score_player_2 == total_laps:
			if GlobalVars.total_players == 2:
				pause_label.text = "PLAYER 2 WINS!!!"
			else:
				pause_label.text = str(total_laps) + " laps: " +  minutes_label.text + seconds_label.text + milliseconds_label.text
			pause_menu_layer.show()
			retry_button.show()
			resume_button.hide()
			get_tree().paused = true
		player_2_label.text = "P2 LAPS: " + str(score_player_2)

	if GlobalVars.race_style == "POINTS":
		score_player_2 += 1
		if score_player_2 == GlobalVars.points_tag_total:
			pause_label.text = "PLAYER 2 WINS!!!"
			pause_menu_layer.show()
			retry_button.show()
			resume_button.hide()
			get_tree().paused = true
		player_2_label.text = "P1 POINTS: " + str(score_player_2)		

# resets level to race again
func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

# causes score time to start after race begin finishes
func _on_start_timer_timeout() -> void:
	await get_tree().create_timer(4.0).timeout
	get_tree().paused = false	

func _on_resume_button_pressed() -> void:
	pause_menu_layer.hide()
	get_tree().paused = false

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(GlobalVars.main)

func race_timer_time_clock() -> void:
	## my attempt at a timer, not entirely accuracte in miliseconds but good enough
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
