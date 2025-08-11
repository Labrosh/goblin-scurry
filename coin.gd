extends Area2D
@export var margin: float = 16.0

func _ready():
	add_to_group("coin")
	respawn()

func respawn() -> void:
	var size := get_viewport_rect().size
	global_position = Vector2(
		randf_range(margin, size.x - margin),
		randf_range(margin, size.y - margin)
	)
