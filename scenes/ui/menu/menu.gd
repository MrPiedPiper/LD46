extends Control

signal pressed_play

func _on_TextureButton_pressed():
	emit_signal("pressed_play")
