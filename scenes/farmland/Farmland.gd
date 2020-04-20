extends Node2D

onready var collider = $Area2D/CollisionShape2D
onready var sprite_speed = $SpeedSprite
onready var sprite_quality = $QualitySprite

export var speed_texture:Texture
export var quality_texture:Texture

var is_speed_upgraded = false
var is_quality_upgraded = false

func _process(delta):
	if $Crop.get_child_count() == 0:
		collider.disabled = false
	else:
		collider.disabled = true

func plant_crop(scene:PackedScene):
	var new_crop = scene.instance()
	if is_speed_upgraded: new_crop.growth_time = 5
	if is_quality_upgraded: new_crop.plant_value = 20
	$Crop.add_child(new_crop)

func upgrade_speed():
	is_speed_upgraded = true
	sprite_speed.visible = true

func upgrade_quality():
	is_quality_upgraded = true
	sprite_quality.visible = true
