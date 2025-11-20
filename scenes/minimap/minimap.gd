extends Control
class_name Minimap

@export var world_size: Vector2 = Vector2(1152, 656)
@export var player_path: NodePath
@export var camera_path: NodePath

@onready var camera: Camera2D = get_node(camera_path)

var tokens: Array[MinimapToken] = []

func _ready() -> void:
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if not camera:
		return
	
	var bg_color = Color(0.2, 0.4, 0.8, 0.5)
	draw_rect(Rect2(Vector2.ZERO, size), bg_color)
	
	var scale_x = size.x / world_size.x
	var scale_y = size.y / world_size.y
	var scale_factor = min(scale_x, scale_y)
	
	var offset_x = (size.x - world_size.x * scale_factor) / 2
	var offset_y = (size.y - world_size.y * scale_factor) / 2
	
	update_camera(offset_x, offset_y, scale_factor)
	update_tokens(offset_x, offset_y, scale_factor)
	
func update_camera(offset_x: float, offset_y: float, scale_factor: float) -> void:
	var viewport_size = get_viewport().size
	var camera_world_size = viewport_size / camera.zoom.x
	var camera_world_rect = Rect2(
		camera.get_screen_center_position() - camera_world_size / 2,
		camera_world_size
	)
	var camera_rect = Rect2(
		offset_x + camera_world_rect.position.x * scale_factor,
		offset_y + camera_world_rect.position.y * scale_factor,
		camera_world_rect.size.x * scale_factor,
		camera_world_rect.size.y * scale_factor
	)
	var camera_color = Color(1, 1, 1, 0.8)
	draw_rect(camera_rect, camera_color, false, 2.0)
	
	
func update_tokens(offset_x: float, offset_y: float, scale_factor: float) -> void:
	for token in tokens:
		var token_pos = Vector2(
			offset_x + token.global_position.x * scale_factor,
			offset_y + token.global_position.y * scale_factor
		)
		draw_circle(token_pos, 3.0, token.color)
	
func add_token(token: MinimapToken) -> void:
	tokens.append(token)
	
func remove_token(token: MinimapToken) -> void:
	tokens.erase(token)
