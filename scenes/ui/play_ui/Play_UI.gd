extends Control

onready var score_label = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/Label2
onready var inventory_curr = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Label3
onready var inventory_max = $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/Label2

func set_score(new_text):
	score_label.text = str(new_text)

func set_inventory_curr(new_text):
	inventory_curr.text = str(new_text)
	
func set_inventory_max(new_text):
	inventory_max.text = str(new_text)
