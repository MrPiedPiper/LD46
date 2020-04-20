extends Node2D

export var speed_sprite:Texture
export var quality_sprite:Texture
export var hoe_sprite:Texture
export var fert:PackedScene
export var hoe:PackedScene
export var ui_price:Texture
export var price:int = 500
export(int,"None","Speed Fert","Quality Fert","Hoe") var drop_type

enum TYPE{
	NONE,
	SPEED_FERT,
	QUALITY_FERT,
	HOE
}

onready var vending_sprite = $Sprite
onready var vending_animation = $AnimationPlayer
onready var vending_area_collision = $Area2D/CollisionShape2D

func _ready():
	match drop_type:
		TYPE.NONE:
			pass
		TYPE.SPEED_FERT:
			vending_sprite.texture = speed_sprite
		TYPE.QUALITY_FERT:
			vending_sprite.texture = quality_sprite
		TYPE.HOE:
			vending_sprite.texture = hoe_sprite

func activate():
	vending_animation.play("used")
	vending_area_collision.set_deferred("disabled", true)
