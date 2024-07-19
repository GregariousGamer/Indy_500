extends CharacterBody2D

const acceleration: float = 1.0

@export var speed: float = 10.0
@export var rotation_speed: float = 2.0
@export var friction: float = acceleration / speed * 10.0
@export var move_input: float
@export var rotation_direction: float
@export var max_speed: float = 1000.0
@export var turn_speed_minimum: float = 150.0

func _process(delta: float) -> void:
	# seperate from physics process
	apply_traction(delta)
	apply_friction(delta)
 
func _physics_process(delta: float) -> void:
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
		apply_turn_friction(delta)
		traction.x += 1.0
	
	traction = traction.normalized() # have to normalize or always moving

	velocity += transform.x * move_input * speed * acceleration # includes direction and move input and acceleration
	if velocity != Vector2.ZERO: # stops the car from rotating if not moving
		if abs(velocity.y) || abs(velocity.x) >= turn_speed_minimum: # minimum speed required to turn effectively
			rotation += rotation_direction * rotation_speed * delta

# called every tick to slow the car down if not moving	
func apply_friction(delta: float) -> void:
	velocity -= velocity * friction * delta 

# called when right or left are held down, reduces speed for more realistic driving	
func apply_turn_friction(delta: float) -> void:
	velocity -= (velocity * friction * delta) / 250
