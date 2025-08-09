extends Area2D

signal bonked

@export var speed: float = 200.0
var direction := 1

func _process(delta):
	position.x += speed * direction * delta
	var screen_width = get_viewport_rect().size.x
	var half_width = 16 # adjust for sprite size

	if direction == 1 and position.x >= screen_width - half_width:
		position.x = screen_width - half_width
		direction = -1
		emit_signal("bonked")
	elif direction == -1 and position.x <= 0 + half_width:
		position.x = 0 + half_width
		direction = 1
		emit_signal("bonked")
