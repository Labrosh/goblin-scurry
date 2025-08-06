extends TextureRect

var gold := 0
var gold_per_trip := 1
var speed := 200.0
var direction := 1

var cost_pockets := 10
var cost_feet := 15
var cost_wagon := 50

var gold_last_tick := 0
var gold_timer := 0.0
var quote_cooldown := 0.0

@export var gold_label: Label
@export var gps_label: Label
@export var goblin_quote: Label
@export var button_pockets: Button
@export var button_feet: Button
@export var button_wagon: Button

func _ready():
	button_pockets.pressed.connect(on_pockets_upgrade)
	button_feet.pressed.connect(on_feet_upgrade)
	button_wagon.pressed.connect(on_wagon_upgrade)

	update_button_texts()
	update_gold()
	update_buttons()
	update_quote()

	button_pockets.tooltip_text = "Carry more per trip!"
	button_feet.tooltip_text = "Move faster across the screen!"
	button_wagon.tooltip_text = "Massive goblin logistics upgrade!"

func _process(delta):
	var new_pos = position.x + (speed * direction * delta)
	position.x = new_pos

	var screen_width = get_viewport_rect().size.x
	var goblin_width = size.x

	quote_cooldown -= delta
	gold_timer += delta

	var gps_interval := 5.0
	if gold_timer >= gps_interval:
		var gps = float(gold - gold_last_tick) / gps_interval
		gps_label.text = "Gold/sec: %.2f" % gps
		gold_last_tick = gold
		gold_timer = 0

	if direction == 1 and position.x >= screen_width - goblin_width:
		position.x = screen_width - goblin_width
		direction = -1
		add_gold()
	elif direction == -1 and position.x <= 0:
		position.x = 0
		direction = 1
		add_gold()

func add_gold():
	gold += gold_per_trip
	update_gold()
	update_buttons()
	bonk_effect()
	if quote_cooldown <= 0:
		update_quote()
		quote_cooldown = 1.5
	if gold >= 100:
		win_game()

func update_gold():
	gold_label.text = "Gold: %d" % gold

func update_quote():
	var quotes = [
		"Shiny for the stash!",
		"Whee!",
		"More loot!",
		"Gobbo go!",
		"Speed is life.",
		"I saw a squirrel!"
	]
	goblin_quote.text = quotes[randi() % quotes.size()]

func update_button_texts():
	button_pockets.text = "Buy Pockets Upgrade (%d)" % cost_pockets
	button_feet.text = "Buy Feet Upgrade (%d)" % cost_feet
	if button_wagon.text != "✔ Wagon Upgrade":
		button_wagon.text = "Buy Wagon Upgrade (%d)" % cost_wagon

func update_buttons():
	button_pockets.disabled = gold < cost_pockets
	button_feet.disabled = gold < cost_feet
	if button_wagon.text != "✔ Wagon Upgrade":
		button_wagon.disabled = gold < cost_wagon

func on_pockets_upgrade():
	if gold >= cost_pockets:
		gold -= cost_pockets
		gold_per_trip += 1
		cost_pockets = int(cost_pockets * 1.25)
		update_button_texts()
		update_gold()
		update_buttons()

func on_feet_upgrade():
	if gold >= cost_feet:
		gold -= cost_feet
		speed += 50
		cost_feet = int(cost_feet * 1.5)
		update_button_texts()
		update_gold()
		update_buttons()

func on_wagon_upgrade():
	if gold >= cost_wagon:
		gold -= cost_wagon
		gold_per_trip += 10
		speed += 100
		button_wagon.text = "✔ Wagon Upgrade"
		button_wagon.disabled = true
		update_gold()
		update_buttons()

func bonk_effect():
	scale = Vector2(1.1, 0.9)
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(1, 1)

func win_game():
	get_tree().paused = true
	goblin_quote.text = "Retired rich!"
	gold_label.text += " – YOU WIN!"
