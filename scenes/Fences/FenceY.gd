extends Node2D

export var open_cost = 100

onready var gate = $Gate/Sprite
onready var area = $Area2D/CollisionShape2D
onready var gate_shape = $StaticBody2D/GateShape

func open_gate():
	gate.frame = 1
	area.disabled = true
	gate_shape.disabled = true
