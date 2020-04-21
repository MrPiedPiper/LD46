extends Node2D

signal swung
signal bar_done
signal touched_crop

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var bar = $Bar
onready var tween = $Tween

export var item_icon:Texture

var is_tool = true
var is_busy = false

var is_scanning = false

func _ready():
	bar.set_as_toplevel(true)

func swing():
	if is_scanning:
		return
	animation_player.play("Swing")
	is_busy = true
	yield(animation_player,"animation_finished")
	is_busy = false
	activate_bar()

func activate_bar():
	is_scanning = true
	var camera_dimensions = Vector2(320,192)
	var cam_pos = Vector2(stepify(global_position.x-camera_dimensions.x,camera_dimensions.x*2)+camera_dimensions.x,stepify(global_position.y-camera_dimensions.y,camera_dimensions.y*2)+camera_dimensions.y)
	var start_pos = cam_pos
	var end_pos = cam_pos - camera_dimensions
	end_pos.y = camera_dimensions.y
	start_pos.y += camera_dimensions.y/2
	end_pos.y = start_pos.y
	start_pos.x += 8
	end_pos.x -= 8
	bar.position = start_pos
	tween.interpolate_property(bar,"position",start_pos,end_pos,5,Tween.TRANS_LINEAR)
	tween.start()
	bar.visible = true

func _on_Tween_tween_completed(object, key):
	is_scanning = false
	bar.visible = false
	emit_signal("swung")


func _on_Area2D_area_entered(area):
	if area.owner.is_in_group("crop"):
		emit_signal("touched_crop",area.owner)
