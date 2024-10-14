extends TouchScreenButton

@onready var max_distance = shape.radius
@onready var transparency_level = 0.5

var stick_center: Vector2 = texture_normal.get_size() / 2
var touched: bool = false

func _ready():
	modulate = Color(1, 1, 1, transparency_level)
	%Knob.modulate = Color(1, 1, 1, transparency_level)

func _read():
	set_process(false)
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			set_process(true)
		elif not event.pressed:
			set_process(false)
			%Knob.position = stick_center

func _process(delta):
	%Knob.global_position = get_global_mouse_position()
	%Knob.position = stick_center + (%Knob.position - stick_center).limit_length(max_distance)
	
func get_joystick_dir() -> Vector2:
	var dir = %Knob.position - stick_center
	return dir.normalized()
