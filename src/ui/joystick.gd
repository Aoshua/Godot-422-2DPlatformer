extends TouchScreenButton

@onready var max_distance = shape.radius
@onready var transparency_level = 0.5
@onready var knob = $Knob

var stick_center: Vector2 = Vector2.ZERO # WAS: texture_normal.get_size() / 2
var touched: bool = false
var touch_index: int = -1 # Track which touch is controlling the joystick

func _ready():
	modulate = Color(1, 1, 1, transparency_level)
	knob.modulate = Color(1, 1, 1, transparency_level)
	stick_center = knob.position # Store the initial knob center position

func _input(event):
	if event is InputEventScreenTouch:
		# If the touch begins and the joystick is not being touched
		if event.pressed and touch_index == -1:
			# Check if the touch occurs inside the joystick's boundaries
			var global_position = get_global_position()
			var size = Vector2(150, 150)
			var rect = Rect2(global_position - size / 2, size) # 150 is the diameter of the button

			if rect.has_point(event.position):
				touch_index = event.index  # Track the active touch
				touched = true
				
		# If the touch ends and it's the tracked touch
		elif not event.pressed and event.index == touch_index:
			touch_index = -1 # Reset the tracked touch
			touched = false
			reset_joystick_position()
			
	# Handle drag event
	if event is InputEventScreenDrag and event.index == touch_index:
		move_knob(event.position)

func _process(delta):
	# Constrain the knob's movement within max_distance
	if touched:
			knob.position = stick_center + (knob.position - stick_center).limit_length(max_distance)

# Moves the knob based on the touch position
func move_knob(touch_position: Vector2) -> void:
	# Convert the global touch position to local (relative to the joystick)
	var local_touch_pos = to_local(touch_position)
	knob.position = stick_center + (local_touch_pos - stick_center).limit_length(max_distance)

# Reset the joystick to its center position when released
func reset_joystick_position() -> void:
	knob.position = stick_center

# Get the direction the joystick is being pushed in (normalized vector)
func get_joystick_dir() -> Vector2:
	var dir = knob.position - stick_center
	if dir.length() > 0:
		return dir.normalized()
	return Vector2.ZERO
