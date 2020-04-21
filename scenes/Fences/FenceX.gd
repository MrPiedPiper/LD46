extends Node2D

export var open_cost = 100
export var is_auto_priced = true
export var custom_cost_sprite:Texture

onready var top_gate = $TopGate/Sprite
onready var bottom_gate = $BottomGate/Sprite
onready var area = $Area2D/CollisionShape2D
onready var gate_shape = $StaticBody2D/GateShape

onready var audio = $AudioStreamPlayer2D

func open_gate():
	top_gate.frame = 1
	bottom_gate.frame = 1
	area.disabled = true
	gate_shape.disabled = true
	audio.play(0)
