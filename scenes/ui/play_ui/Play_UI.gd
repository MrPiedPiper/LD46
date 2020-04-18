extends Control

onready var score_label = $MarginContainer/MarginContainer/HBoxContainer/HBoxContainer/Label2

func set_score(new_text):
	score_label.text = str(new_text)
