extends Node2D
class_name MinimapToken

@export var color: Color
var minimap: Minimap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	minimap = get_tree().get_root().get_node("Game/CanvasLayer/Minimap")
	minimap.add_token(self)

func _exit_tree() -> void:
	minimap.remove_token(self)
