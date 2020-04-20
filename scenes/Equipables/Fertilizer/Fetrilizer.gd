extends Node2D

signal swung

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var poi:Node2D = $POI

export(int,"Speed","Quality") var fert_type
export var speed_sprite:Texture
export var speed_icon:Texture
export var quality_sprite:Texture
export var quality_icon:Texture

var anim_sprite:Texture
var item_icon:Texture

enum TYPE{
	SPEED,
	QUALITY
}

var is_tool = true
var is_busy = false

var is_touching_farmland = false
var was_swing_on_farmland = false

var touched_farmland

func _ready():
	match fert_type:
		TYPE.SPEED:
			anim_sprite = speed_sprite
			item_icon = speed_icon
		TYPE.QUALITY:
			anim_sprite = quality_sprite
			item_icon = quality_icon

func check_for_farmland():
	was_swing_on_farmland = is_touching_farmland

func swing():
	animation_player.play("shake")
	is_busy = true
	yield(animation_player,"animation_finished")
	is_busy = false
	emit_signal("swung",self,touched_farmland)


func _on_Area2D_area_entered(area):
	if area.owner != null and area.owner.is_in_group("farmland"):
		touched_farmland = area.owner
		is_touching_farmland = true

func _on_Area2D_area_exited(area):
	if area.owner != null and area.owner.is_in_group("farmland"):
		is_touching_farmland = false
