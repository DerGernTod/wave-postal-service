extends Sprite2D

@export var acceleration: float = 500.0
@export var drag: float = 5.0
@export var background: Sprite2D

var velocity: Vector2 = Vector2.ZERO
var viewport_size: Vector2
var time_elapsed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport_rect().size
	background = get_parent().get_node("Background")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity += direction * acceleration * delta
	velocity -= velocity * drag * delta
	position += velocity * delta
	
	# Clamp position to viewport bounds
	position.x = clamp(position.x, 0, viewport_size.x)
	position.y = clamp(position.y, 0, viewport_size.y)
	
	time_elapsed += delta
	
	# Update shader uniforms
	if background and background.material:
		var normalized_pos = position / viewport_size
		background.material.set_shader_parameter("ripple_center", normalized_pos)
		background.material.set_shader_parameter("time", time_elapsed)
