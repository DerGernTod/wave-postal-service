extends Control
class_name Minimap

@export var world_size: Vector2 = Vector2(1152, 656)
@export var player_path: NodePath
@export var camera_path: NodePath

@onready var player: CharacterBody2D = get_node(player_path)
@onready var camera: Camera2D = get_node(camera_path)

func _ready() -> void:
	queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if not player or not camera:
		return
	
	var bg_color = Color(0.2, 0.4, 0.8, 0.5)
	draw_rect(Rect2(Vector2.ZERO, size), bg_color)
	
	var scale_x = size.x / world_size.x
	var scale_y = size.y / world_size.y
	var scale_factor = min(scale_x, scale_y)
	
	var offset_x = (size.x - world_size.x * scale_factor) / 2
	var offset_y = (size.y - world_size.y * scale_factor) / 2
	
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
	
	var player_pos = Vector2(
		offset_x + player.position.x * scale_factor,
		offset_y + player.position.y * scale_factor
	)
	var player_color = Color(1, 0, 0)
	draw_circle(player_pos, 4.0, player_color)
