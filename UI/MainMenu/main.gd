extends Node2D

@onready var level_button: Button = $MainMenu/MarginContainer/VBoxContainer/TrackBox/LevelButton
@onready var level_label: Label = $MainMenu/MarginContainer/VBoxContainer/TrackBox/LevelLabel
@onready var players_button: Button = $MainMenu/MarginContainer/VBoxContainer/PlayersBox/PlayersButton
@onready var players_label: Label = $MainMenu/MarginContainer/VBoxContainer/PlayersBox/PlayersLabel
@onready var start_button: Button = $MainMenu/MarginContainer/VBoxContainer/StartBox/StartButton
@onready var button_sound: AudioStreamPlayer2D = $ButtonSound

@onready var race_type_button: Button = $MainMenu/MarginContainer/VBoxContainer/RaceType/RaceTypeButton
@onready var race_type_label: Label = $MainMenu/MarginContainer/VBoxContainer/RaceType/RaceTypeLabel
@onready var laps_label: Label = $MainMenu/MarginContainer/VBoxContainer/RaceType/LapsLabel
@onready var quantity_button: Button = $MainMenu/MarginContainer/VBoxContainer/RaceType/QuantityButton


var race_types: Array[String] = ["RACE", "POINTS", "TAG"]
var race_types_counter: int

var laps_style: Array[String] = ["LAPS", "TOTAL", "TIME"]
var laps_style_counter: int

var laps_number: Array[int] = [3, 5, 7]
var laps_number_counter: int
var time_cap: Array[int] = [1, 2, 3, 4, 5]
var time_cap_counter: int
var points_total: Array = [5, 10, 15, 20, 25, 50]
var points_total_counter: int

var level: int = 1
var num_players: int = 1

func _on_start_button_pressed() -> void:
	GlobalVars.total_players = num_players # determines whether one or two players spawn
	if race_type_label.text == "RACE":
		GlobalVars.lap_select = laps_number[laps_number_counter] # total number of laps for victory
		GlobalVars.race_style = "RACE"
	elif race_type_label.text == "POINTS":
		GlobalVars.race_style = "POINTS"
		GlobalVars.points_tag_total = int(quantity_button.text)
	elif race_type_label.text == "TAG":
		GlobalVars.race_style = "TAG"
		GlobalVars.points_tag_total = int(quantity_button.text)
		
	button_sound.play()
	
	if level == 1:
		GlobalVars.track_select = 1
		get_tree().change_scene_to_file(GlobalVars.track_1)

# one or two players, shows start button because can't start tag or points w/ 1 player
func _on_players_button_pressed() -> void:
	button_sound.play()
	
	if num_players == 1:
		num_players = 2
		players_label.text = str(2)
	
	elif num_players == 2:
		num_players = 1
		players_label.text = str(1)
	
	if race_type_label.text != "RACE":
		if players_label.text != "2":
			start_button.hide()
		else:
			start_button.show()
		
# does nothing yet, only one level
func _on_level_button_pressed() -> void:
	button_sound.play()

# race, points, tag and changes labels accordingly
func _on_race_type_button_pressed() -> void:
	button_sound.play()
	if race_types_counter == 2:
		race_types_counter = 0
		laps_style_counter = 0
	else:
		race_types_counter += 1
		laps_style_counter += 1

	race_type_label.text = race_types[race_types_counter]
	laps_label.text = laps_style[laps_style_counter]
	
	if race_types_counter == 0:
		start_button.show()
		quantity_button.text = str(laps_number[0])
	elif race_types_counter == 1:
		if players_label.text != "2":
			start_button.hide()
		quantity_button.text = str(points_total[0])
	elif race_types_counter == 2:
		if players_label.text != "2":
			start_button.hide()
		quantity_button.text = str(time_cap[0])

# changes labels to reflect the current type of race		
func _on_quantity_button_pressed() -> void:
	button_sound.play()
	if race_type_label.text == "RACE":
		if laps_number_counter == 2:
			laps_number_counter = 0
		else:
			laps_number_counter += 1
			
		quantity_button.text = str(laps_number[laps_number_counter])
	
	if race_type_label.text == "POINTS":
		if points_total_counter == 5:
			points_total_counter = 0
		else:
			points_total_counter += 1
			
		quantity_button.text = str(points_total[points_total_counter])
	
	if race_type_label.text == "TAG":
		if time_cap_counter == 4:
			time_cap_counter = 0
		else:
			time_cap_counter += 1
			
		quantity_button.text = str(time_cap[time_cap_counter])
