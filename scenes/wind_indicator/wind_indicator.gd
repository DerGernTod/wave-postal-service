extends TextureRect
class_name WindIndicator

var wind_direction: Vector2 = Vector2.LEFT
var next_change_in: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size / 2
	_trigger_change()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var elapsed = Time.get_ticks_msec()
	var added_rotation = sin(elapsed * 0.003) * 0.3
	var target_rotation = wind_direction.angle() + added_rotation + PI * .5
	rotation = lerp_angle(rotation, target_rotation, delta)
	next_change_in -= delta
	if next_change_in < 0:
		_trigger_change()

func _trigger_change() -> void:
	next_change_in = 5 + randf() * 6
	var new_direction = wind_direction.rotated(PI * .25 + randf() * PI * 1.25) # at least 45°
	print(rad_to_deg(new_direction.angle()))
	
	wind_direction = new_direction

func get_wind_direction() -> Vector2:
	return wind_direction
