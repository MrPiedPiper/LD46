extends Control

onready var inventory_count_parent = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer2/MarginContainer2/HBoxContainer2/InventoryCountHBoxContainer
onready var inventory_size_parent = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer2/MarginContainer2/HBoxContainer2/InventorySizeHBoxContainer
onready var inventory_texture_rect = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer2/MarginContainer2/HBoxContainer2/TextureRect
onready var score_count_parent = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer/MarginContainer/MarginContainer/HBoxContainer2/ScoreCountHBoxContainer
onready var equipped_texture_rect = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer2/MarginContainer2/MarginContainer2/InventoryHBoxContainer/CenterContainer/EquippedScaleParent/EquippedTextureRect
onready var animation_player = $AnimationPlayer
onready var message_box = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer2/MarginContainer/Control/MarginContainer/TextureRect
onready var message_box_hider = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer2/MarginContainer/Control
onready var problem_box = $CanvasLayer/MarginContainer3/VBoxContainer/HBoxContainer

export var inventory_default_icon:Texture
export var inventory_upgrage_icon:Texture
export var inventory_upgrage2_icon:Texture
export var number_texture:Texture
export(Array,Texture) var gate_price_array
export(Array,Texture) var vending_price_array

var number_dict = {}

func _process(delta):
	var problem = $CanvasLayer/MarginContainer3
	problem.rect_size = Vector2(320,192)
	pass

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
		i.queue_free()
	var number_string = str(number)
	for i in number_string:
		var new_texture = TextureRect.new()
		new_texture.size_flags_vertical = SIZE_SHRINK_CENTER
		new_texture.texture = number_dict[i]
		parent_node.add_child(new_texture)

func set_equipped(new_texture:Texture):
	animation_player.stop(true)
	animation_player.play("scroll_inventory")
	equipped_texture_rect.texture=new_texture

func display_gate_message(message_number):
	display_message(gate_price_array[message_number])

func display_vending_message(message_number):
	display_message(vending_price_array[message_number])

func display_message(new_message):
	message_box.texture = new_message

func hide_message():
	message_box_hider.visible = false

func show_message():
	message_box_hider.visible = true

func upgrade_inventory():
	if inventory_texture_rect.texture == inventory_default_icon:
		inventory_texture_rect.texture = inventory_upgrage_icon
	elif inventory_texture_rect.texture == inventory_upgrage_icon:
		inventory_texture_rect.texture = inventory_upgrage2_icon
