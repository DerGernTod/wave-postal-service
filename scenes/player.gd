extends CharacterBody2D
class_name Player

@export var acceleration: float = 500.0
@export var drag: float = 5.0
@export var wind_indicator: WindIndicator;
@export var sprite: Sprite2D

var viewport_size: Vector2
var time_elapsed: float = 0.0
var debug_color: Color = Color.WHITE
var active_currents: Array = []
var held_bottles: Array[Bottle] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var wind_dir = wind_indicator.get_wind_direction().normalized()
	var accel_power = acceleration
	
	if direction == Vector2.ZERO:
		debug_color = Color.WHITE
		velocity += wind_dir * acceleration * 0.2 * delta
	else:
		var dot = direction.normalized().dot(wind_dir)
		if dot > 0.90: # go with the wind
			accel_power *= 2
			debug_color = Color.GREEN
		elif dot < -0.3: # against the wind
			accel_power *= 0.6
			debug_color = Color.RED
		else:
			debug_color = Color.WHITE
	
	velocity += direction * accel_power * delta
	
	velocity += _apply_current_boost(delta)
	
	velocity -= velocity * drag * delta
	move_and_slide()
	
	queue_redraw()
	
	time_elapsed += delta

func _apply_current_boost(delta: float) -> Vector2:
	if active_currents.is_empty():
		return Vector2.ZERO
		
	var total_strength = 0.0
	var combined_dir = Vector2.ZERO
	for current in active_currents:
		total_strength = max(current.get_strength(), total_strength)
		combined_dir += current.get_direction() * current.get_strength()
	combined_dir = combined_dir.normalized()
	return combined_dir * total_strength * delta

func _draw() -> void:
	draw_line(Vector2.ZERO, velocity * 2, debug_color, 2)

func add_current(current: CurrentArea) -> void:
	if not active_currents.has(current):
		active_currents.append(current)

func remove_current(current: CurrentArea) -> void:
	active_currents.erase(current)
	
func collect_bottle(bottle: Bottle) -> void:
	held_bottles.append(bottle)
	
func drop_bottle() -> bool:
	var bottle = held_bottles.pop_back()
	if bottle != null:
		bottle.queue_free()
		return true
	return false
	
