extends Node2D

onready var collider = $Area2D/CollisionShape2D

func _process(delta):
	if $Crop.get_child_count() == 0:
		collider.disabled = false
	else:
		collider.disabled = true

func plant_crop(scene:PackedScene):
	var new_crop = scene.instance()
	$Crop.add_child(new_crop)
