extends CharacterBody2D

signal emit_particles
signal car_sound

const acceleration: float = 1.5

@export var speed: float = 3.5
@export var rotation_speed: float = 1.75
@export var friction: float = acceleration / speed * 2.5
@export var move_input: float
@export var rotation_direction: float
@export var max_speed: float = 1000.0
@export var turn_speed_minimum: float = 30.0

var pitch_minimum: float = 1.0
var pitch_maximum: float = 1.5

var seconds: int

@onready var car_trails: GPUParticles2D = $CarTrails
@onready var car_trails_2: GPUParticles2D = $CarTrails2
@onready var car_driving: AudioStreamPlayer2D = $CarDriving
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer



func _ready() -> void:
	self.connect("emit_particles", emit_particles_func)
	self.connect("car_sound", car_sound_func)
	
	self.scale *= 2
	
	animation_player.stop()
	
func _process(delta: float) -> void:	
	# seperate from physics process
	apply_traction(delta)
	apply_friction(delta)
	
	if car_driving.pitch_scale <= 0.99:
		car_driving.stop()
	
	if Input.is_action_pressed("ui_up"):
		if car_driving.pitch_scale <= pitch_maximum:
			car_driving.pitch_scale *= 1.001
	elif !Input.is_action_pressed("ui_up"):
		if !car_driving.pitch_scale < 0.99:
			car_driving.pitch_scale -= 0.005
 
func _physics_process(_delta: float) -> void:
	if GlobalVars.race_style == "TAG":
		var collision_info = get_last_slide_collision()
		if collision_info:
			var colliding_body: Object = collision_info.get_collider()
			if (colliding_body.is_in_group("car")
			&& GlobalVars.point_box_deleted == true):
				if GlobalVars.player_one_glowing == true:
					GlobalVars.player_one_glowing = false
					GlobalVars.player_two_glowing = true
					
				elif GlobalVars.player_one_glowing == false:
					GlobalVars.player_one_glowing = true
					GlobalVars.player_two_glowing = false
		
		if GlobalVars.player_one_glowing == true:
			animation_player.play("flash")
			if seconds == 60:
				SignalManager.player_1_point.emit()
		elif GlobalVars.player_one_glowing == false:
			animation_player.stop()
	if seconds > 60:
		seconds = 0	

	seconds += 1
	

	
	move_input = Input.get_axis("ui_up", "ui_down")
	rotation_direction = Input.get_axis("ui_left", "ui_right")

	# sets max speed that car can go
	if velocity.y > max_speed:
		velocity.y = max_speed
	if velocity.y < -(max_speed):
		velocity.y = -(max_speed)
	if velocity.x > max_speed:
		velocity.x = max_speed
	if velocity.x < -(max_speed):
		velocity.x = -(max_speed)
		
	move_and_slide() # necessary to move the car
	


func apply_traction(delta: float) -> void:
	var traction: Vector2 = Vector2.ZERO # can tell which direction going
	if Input.is_action_pressed("ui_up"):
		traction.y -= 1
	if Input.is_action_pressed("ui_down"):
		traction.y += 1
	if Input.is_action_pressed("ui_left"):
		traction.x -= 1.0
		apply_turn_friction(delta)
	if Input.is_action_pressed("ui_right"):
		traction.x += 1.0
		apply_turn_friction(delta)
	
	traction = traction.normalized() # have to normalize or always moving

	velocity += transform.x * move_input * speed * acceleration # includes direction and move input and acceleration
	if velocity != Vector2.ZERO: # stops the car from rotating if not moving
		if (abs(velocity.y) >= turn_speed_minimum || abs(velocity.x) >= turn_speed_minimum): # minimum speed required to turn effectively
			rotation += rotation_direction * rotation_speed * delta
			emit_particles.emit(1)
		else:
			emit_particles.emit(0)
		
		if car_driving.pitch_scale >= 1:
			car_sound.emit()

# called every tick to slow the car down if not moving	
func apply_friction(delta: float) -> void:
	velocity -= velocity * friction * delta 

# called when right or left are held down, reduces speed for more realistic driving	
func apply_turn_friction(delta: float) -> void:
	velocity -= (velocity * friction * delta) / 1.5
	
func emit_particles_func(x: int) -> void:
	if (Input.is_action_pressed("ui_left")
	|| Input.is_action_pressed("ui_right")):
		if x == 1:
			car_trails.emitting = true
			car_trails_2.emitting = true
		elif x == 0:
			car_trails.emitting = false
			car_trails_2.emitting = false
	if (Input.is_action_just_released("ui_left")
	|| Input.is_action_just_released("ui_right")):
			car_trails.emitting = false
			car_trails_2.emitting = false

func car_sound_func() -> void:
	car_driving.play()
