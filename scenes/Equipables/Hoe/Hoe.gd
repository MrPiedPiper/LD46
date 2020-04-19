extends Node2D

signal swung

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var poi:Node2D = $POI

export var item_icon:Texture

var is_tool = true
var is_busy = false

var is_touching_farmland = false
var was_swing_on_farmland = false

func check_for_farmland():
	was_swing_on_farmland = is_touching_farmland

func swing():
	animation_player.play("Swing")
	is_busy = true
	yield(animation_player,"animation_finished")
	is_busy = false
	emit_signal("swung",poi.global_position)


func _on_Area2D_area_entered(area):
	if area.owner != null and area.owner.is_in_group("farmland"):
		is_touching_farmland = true

func _on_Area2D_area_exited(area):
	if area.owner != null and area.owner.is_in_group("farmland"):
		is_touching_farmland = false
