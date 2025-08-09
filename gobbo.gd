extends Area2D
signal coin_collected

@export var speed: float = 160.0
@export var coin: Area2D   # leave blank in Inspector, drag CoinSprite into here

func _ready():
	area_entered.connect(_on_area_entered)

func _process(delta):
	var target := get_global_mouse_position()
	var v := target - global_position
	if v.length() > 1.0:
		global_position += v.normalized() * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		emit_signal("coin_collected")
		if coin == area:
			coin.respawn()
