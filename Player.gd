extends KinematicBody2D

signal deposited_in_bin
signal got_score
signal got_item
signal swung_tool
signal scrolled_inventory

var velocity = Vector2.ZERO

const MAX_SPEED = 50
const ACCELERATION = 500
const FRICTION = 500

export var test_plant:PackedScene = load("res://scenes/crop/Crop.tscn")

onready var hoe = $Hand/ToolOffset/Hoe
onready var item_parent = $Hand/ItemOffset
onready var tool_parent = $Hand/ToolOffset

# animation variables
onready var animationPlayer = $AnimationPlayer
var is_facing_right = true

enum {
	IDLE,
	RUN
}

var is_swinging_hoe = false

#Variable holds a list of all crop areas the player is touching
var touching_list_crops = []
#Variable holds a list of all farmland areas the player is touching
var touching_list_farmland = []

var is_touching_bin = false

var sellable_size = 3
#Variable holds all sellable items in the player's inventory
var sellable_list = []
var inventory_list = []
#Items are stored in an array of intentory items made with this class
class sellable_item:
	var item_name:String
	var item_icon:Texture
	var item_value:int
	func _init(new_item_name:String,new_item_icon:Texture,new_item_value:int):
		item_name = new_item_name
		item_icon = new_item_icon
		item_value = new_item_value

#Score storage? Not sure it's a good idea to have this here, but it'll work for now I suppose.
var score = 0

func _process(delta):
	move_state(delta)
	
	if Input.is_action_just_pressed("action_interact"):
		if is_touching_bin and sellable_list.size() > 0:
			#Get specific item to deposit?
			emit_signal("deposited_in_bin")
			
		if !touching_list_crops.empty() and sellable_list.size() < sellable_size:
			#Get the closest crop
			var closest_crop = return_closest_touching(touching_list_crops)
			#Increment the score by the crop's worth and call the crop's built in "harvest" function
			var received_points = closest_crop.harvest()
			var new_item = sellable_item.new("Test crop",closest_crop.plant_icon,closest_crop.plant_value)
			sellable_list.append(new_item)
			#score += received_points
			#emit_signal("got_score",score)
			inventory_list.append(new_item)
			emit_signal("got_item",new_item)
		elif !touching_list_farmland.empty():
			var closest_farmland = return_closest_touching(touching_list_farmland)
			closest_farmland.plant_crop(test_plant)
	if Input.is_action_just_pressed("action_hit"):
		var curr_tool = inventory_list[0]
		if curr_tool != null and curr_tool.get("is_tool") != null and curr_tool.get("is_tool"):
			if curr_tool == hoe:
				is_swinging_hoe = true
				velocity = Vector2.ZERO
				hoe.swing()

func _ready():
	yield(get_tree(),"idle_frame")
	inventory_list.append(hoe)
	emit_signal("scrolled_inventory",hoe)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var curr_equipped = null
		var new_equipped = null
		var new_array = inventory_list.duplicate(true)
		if event.button_index == BUTTON_WHEEL_DOWN:
			curr_equipped = inventory_list[0]
			var temp = new_array.pop_front()
			new_array.push_back(temp)
			new_equipped = new_array[0]
		elif event.button_index == BUTTON_WHEEL_UP:
			curr_equipped = inventory_list[0]
			var temp = new_array.pop_back()
			new_array.push_front(temp)
			new_equipped = new_array[0]
		if curr_equipped != null:
			update_held_item(new_array)

func update_held_item(new_array):
	var curr_equipped = inventory_list[0]
	var new_equipped = new_array[0]
	if curr_equipped != null: 
		var is_tool = curr_equipped.get("is_tool")
		if is_tool == null or (is_tool != null and !is_tool) or (is_tool != null and is_tool and !curr_equipped.get("is_busy")):
			if new_equipped is sellable_item:
				for i in tool_parent.get_children():
					i.visible = false
				for i in item_parent.get_children():
					item_parent.remove_child(i)
				var new_item = Sprite.new()
				new_item.texture = new_equipped.item_icon
				item_parent.add_child(new_item)
				inventory_list = new_array
				emit_signal("scrolled_inventory",new_equipped)
			elif new_equipped.get("is_tool") != null and new_equipped.get("is_tool"):
				for i in tool_parent.get_children():
					i.visible = false
				for i in item_parent.get_children():
					item_parent.remove_child(i)
				inventory_list = new_array
				new_equipped.visible = true
				emit_signal("scrolled_inventory",new_equipped)

func move_state(delta):
	# get the input strength
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector.x > 0:
		is_facing_right = true
	elif input_vector.x < 0:
		is_facing_right = false 
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		if is_facing_right:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		if is_facing_right:
			animationPlayer.play("IdleRight")
		else:
			animationPlayer.play("IdleLeft")
	
	velocity = move_and_slide(velocity)

#Return the nearest node from an Array
func return_closest_touching(list:Array):
	#If the list is empty
	if list.empty():
		#Say so and exit the function
		print(str(list," is empty!"))
		return
	#Variables for tracking results from the for loop
	var closest_node = null
	var closest_distance = null
	#For each node area
	for i in list:
		#Get the distance between the player and node
		var curr_distance = global_position.distance_to(i.owner.global_position)
		#If the previous number is beat
		if closest_node == null or closest_distance == null or curr_distance < closest_distance:
			#Save the new one
			closest_node = i.owner
			closest_distance = curr_distance
	return closest_node

#When an area is entered
func _on_Area2D_area_entered(area):
	#If the owner of the area touched is in the "bin" group
	if area.owner.is_in_group("bin"):
		#Set to true
		is_touching_bin = true
	#If the owner of the area touched is in the "crop" group
	if area.owner.is_in_group("crop"):
		#Add it to the list
		touching_list_crops.append(area)
	#If the owner of the area touched is in the "farmland" group
	if area.owner.is_in_group("farmland"):
		#Add it to the list
		touching_list_farmland.append(area)
		
#When an area is exited
func _on_Area2D_area_exited(area):
	#If the owner of the area touched area's null or the owner is in the "bin" group
	if area.owner != null and area.owner.is_in_group("bin"):
		is_touching_bin = false
	#If the owner of the area touched area's owner is null (due to being deleted) or is in the "crop" group
	if area.owner == null or area.owner.is_in_group("crop"):
		#Remove it from the list
		touching_list_crops.erase(area)
	if area.owner == null or area.owner.is_in_group("farmland"):
		#Remove it from the list
		touching_list_farmland.erase(area)

func _on_Hoe_swung(hoe_hit_position):
	is_swinging_hoe = false
	if !hoe.was_swing_on_farmland:
		emit_signal("swung_tool",hoe_hit_position)

func on_deposited():
	for i in sellable_list:
		inventory_list.erase(i)
	sellable_list.clear()
	emit_signal("scrolled_inventory",inventory_list[0])
