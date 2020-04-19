extends Control

onready var inventory_count_parent = $CanvasLayer/MarginContainer3/HBoxContainer/MarginContainer2/MarginContainer2/HBoxContainer2/InventoryCountHBoxContainer
onready var inventory_size_parent = $CanvasLayer/MarginContainer3/HBoxContainer/MarginContainer2/MarginContainer2/HBoxContainer2/InventorySizeHBoxContainer
onready var score_count_parent = $CanvasLayer/MarginContainer3/HBoxContainer/MarginContainer/MarginContainer/HBoxContainer2

export var number_texture:Texture

var number_dict = {}

func _ready():
	for i in range(0,10):
		var new_image = AtlasTexture.new()
		new_image.atlas = number_texture
		var number_position = Vector2(6*i,0)
		var number_size = Vector2(6,10)
		new_image.region = Rect2(number_position, number_size)
		number_dict[str(i)] = new_image

func set_score(new_score):
	add_numbers(new_score,score_count_parent)

func set_inventory_curr(new_count):
	add_numbers(new_count,inventory_count_parent)
	
func set_inventory_max(new_count):
	add_numbers(new_count,inventory_size_parent)

func add_numbers(number:int,parent_node):
	for i in parent_node.get_children():
		print(i)
		i.queue_free()
	var number_string = str(number)
	for i in number_string:
		var new_texture = TextureRect.new()
		new_texture.size_flags_vertical = SIZE_SHRINK_CENTER
		new_texture.texture = number_dict[i]
		parent_node.add_child(new_texture)
