extends Node2D

onready var growth_timer:Timer = $GrowthTimer
onready var sprite:Sprite = $Sprite
onready var collision_shape:CollisionShape2D = $Area2D/CollisionShape2D

#Time for each stage of growth in seconds
export var growth_time = 10
#Plant value
export var plant_value = 10
export var plant_image:Texture
export var plant_icon:Texture
export var frame_count:int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.hframes = frame_count
	if plant_image != null:
		sprite.texture = plant_image
	growth_timer.wait_time = growth_time
	growth_timer.start()


func _on_GrowthTimer_timeout():
	sprite.frame += 1
	if sprite.frame != frame_count-1:
		collision_shape.disabled = true
		growth_timer.start()
	else:
		collision_shape.disabled = false

func harvest():
	queue_free()
	return plant_value

