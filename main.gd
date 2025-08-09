extends Node2D
var gold := 0

@onready var goblin: Area2D = $GobboSprite
@onready var gold_label: Label = $CanvasLayer/UI/UI/VBoxContainer2/GoldLabel
@onready var idle_gobbo = $IdleGobbo

func _ready():
	goblin.coin_collected.connect(_on_coin_collected)
	idle_gobbo.bonked.connect(_on_idle_bonk)

func _on_coin_collected():
	gold += 1
	print("Gold:", gold) # debug feedback
	gold_label.text = "Gold: %d" % gold

func _on_idle_bonk():
	gold += 1
	gold_label.text = "Gold: %d" % gold
