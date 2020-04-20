extends Node2D

onready var animation_player = $AnimationPlayer

func play_deposit():
	animation_player.stop(true)
	animation_player.play("Deposit")
