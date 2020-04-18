extends Node2D

onready var ui_play = $UI/Play_UI

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_got_score(new_score):
	score = new_score
	ui_play.set_score(score)
