extends CharacterBody2D

const speed: float = 15.0
const acceleration: float = 50.0
const friction: float = acceleration / speed
const max_speed: float = 10

func _process(delta: float) -> void:
	apply_traction(delta) # only activates if button is pressed
	apply_friction(delta) # applied after traction

	
func _physics_process(delta: float) -> void:
	move_and_collide(velocity) # collides with objects


func apply_traction(delta: float) -> void:
	var traction: Vector2 = Vector2.ZERO # direction of input
	
	if Input.is_action_pressed("ui_up"):
		traction.y -= 1
	if Input.is_action_pressed("ui_down"):
		traction.y += 1
	if Input.is_action_pressed("ui_left"):
		traction.x -= 1
	if Input.is_action_pressed("ui_right"):
		traction.x += 1
		
	traction = traction.normalized() # not sure why normalized
	velocity += traction * acceleration * delta # add velocity every tick
	# clamps max veloctiy to max_speed so it doesn't infinitely accelerate
	velocity.y =min(max_speed, velocity.y)
	velocity.x = min(max_speed, velocity.x)
	
func apply_friction(delta: float) -> void:
	velocity -= velocity * friction * delta # take away velocity every tick

