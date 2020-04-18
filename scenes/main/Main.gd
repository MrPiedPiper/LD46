extends Node2D

onready var ui_play = $UI/Play_UI
onready var player = $Player

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	ui_play.set_inventory_max(player.inventory_size)

func _on_Player_got_score(new_score):
	score = new_score
	ui_play.set_score(score)

func _on_Player_got_item(new_item):
	ui_play.set_inventory_curr(player.inventory_list.size())
	ui_play.set_inventory_max(player.inventory_size)
