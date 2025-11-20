extends AnimatedSprite2D
class_name Progress

@export var duration: float = 1.0

func _ready():
	visible = false
	animation_finished.connect(stop)

func start_progress():
	sprite_frames.set_animation_speed("default", 6.0 / duration)
	visible = true
	play("default")

func hide_sprite():
	visible = false
	stop()
