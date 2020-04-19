extends Node2D

onready var animation_player = $AnimationPlayer

func play_deposit():
	animation_player.play("Deposit")
