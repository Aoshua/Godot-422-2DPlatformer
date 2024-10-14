extends Actor

@export var stomp_impulse = 500.0

func _on_enemy_detector_area_entered(area: Area2D) -> void:
	velocity = calculate_stomp_velocity(velocity, stomp_impulse)
	
func _on_enemy_detector_body_entered(body: Node2D) -> void:
	queue_free()
	
func _physics_process(delta: float) -> void:
	var is_jump_interrupted = Input.is_action_just_released("jump") and velocity.y < 0.0
	var horizontal_input = $CanvasLayer/Joystick.get_joystick_dir()
	var vertical_input = -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	var direction = Vector2(horizontal_input.x, vertical_input)
	velocity = calculate_move_velocity(velocity, direction, is_jump_interrupted)
	move_and_slide()

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), # Left and right at the same time = 0
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0 # y axis negative (-1 for up, 1 for down)
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y # Immediately jump
	if is_jump_interrupted:
		out.y = 0.0
	return out
	
func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out = linear_velocity
	out.y = -impulse # Negates the y velocity
	return out
