extends Node2D

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var progress: Progress = $Progress

var player_in_area: bool = false
var player: CharacterBody2D = null
var attached: bool = false

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player" and not attached:
		player_in_area = true
		player = body
		print("player entered area")

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		_leave_area()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print("player pressing", attached, player_in_area)
	if event.is_action_pressed("interact") and player_in_area and not attached:
		progress.animation_finished.connect(_attach_to_player)
		progress.start_progress()
	elif progress.visible and event.is_action_released("interact"):
		progress.animation_finished.disconnect(_attach_to_player)
		progress.hide_sprite()

func _leave_area() -> void:
	print("player left area")
	player_in_area = false
	player = null
	if progress.visible:
		_disconnect_progress()

func _disconnect_progress() -> void:
	progress.animation_finished.disconnect(_attach_to_player)
	progress.hide_sprite()

func _attach_to_player() -> void:
	attached = true
	var temp_player = player
	var temp_global_scale = global_scale
	get_parent().remove_child(self)
	temp_player.add_child(self)
	position = Vector2(0, -160)
	global_scale = temp_global_scale
	area.monitoring = false
	set_process_input(false)
