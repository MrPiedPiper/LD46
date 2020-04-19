extends Node2D

signal swung

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var poi:Node2D = $POI

var is_touching_farmland = false
var was_swing_on_farmland = false

func _process(delta):
	print(was_swing_on_farmland)

func check_for_farmland():
	was_swing_on_farmland = is_touching_farmland

func swing():
	animation_player.play("Swing")
	yield(animation_player,"animation_finished")
	emit_signal("swung",poi.global_position)


func _on_Area2D_area_entered(area):
	if area.owner != null and area.owner.is_in_group("farmland"):
		is_touching_farmland = true

func _on_Area2D_area_exited(area):
	if area.owner != null and area.owner.is_in_group("farmland"):
		is_touching_farmland = false
