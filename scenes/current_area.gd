extends Area2D
class_name CurrentArea

@export var current_strength: float = 100.0
@export var distance: float = 100.0

var sprites: Array[Sprite2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	for child in get_children():
		if child is Sprite2D:
			sprites.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = Vector2(cos(rotation), sin(rotation))
	for sprite in sprites:
		sprite.position += dir * current_strength * delta
		
		if sprite.position.dot(dir) > distance:
			sprite.position += -2 * distance * dir

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_current"):
		body.add_current(self)

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("remove_current"):
		body.remove_current(self)

func get_direction() -> Vector2:
	return Vector2(cos(rotation), sin(rotation))

func get_strength() -> float:
	return current_strength
