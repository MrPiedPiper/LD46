extends KinematicBody2D

signal deposited_in_bin
signal got_score
signal got_item
signal swung_tool

var velocity = Vector2.ZERO

const MAX_SPEED = 50
const ACCELERATION = 500
const FRICTION = 500

export var test_plant:PackedScene = load("res://scenes/crop/Crop.tscn")

onready var hoe = $Hand/Offset/Hoe
var is_swinging_hoe = false

#Variable holds a list of all crop areas the player is touching
var touching_list_crops = []
#Variable holds a list of all farmland areas the player is touching
var touching_list_farmland = []

var is_touching_bin = false

var inventory_size = 3
#Variable holds all items in the player's inventory
var inventory_list = []
#Items are stored in an array of intentory items made with this class
class inventory_item:
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
	if !is_swinging_hoe:
		move(delta)
	
	if Input.is_action_just_pressed("action_interact"):
		if is_touching_bin and inventory_list.size() > 0:
			#Get specific item to deposit?
			emit_signal("deposited_in_bin")
			
		if !touching_list_crops.empty() and inventory_list.size() < inventory_size:
			#Get the closest crop
			var closest_crop = return_closest_touching(touching_list_crops)
			#Increment the score by the crop's worth and call the crop's built in "harvest" function
			var received_points = closest_crop.harvest()
			var new_item = inventory_item.new("Test crop",closest_crop.plant_image,closest_crop.plant_value)
			inventory_list.append(new_item)
			score += received_points
			#emit_signal("got_score",score)
			emit_signal("got_item",new_item)
		elif !touching_list_farmland.empty():
			var closest_farmland = return_closest_touching(touching_list_farmland)
			closest_farmland.plant_crop(test_plant)
	if Input.is_action_just_pressed("action_hit"):
		is_swinging_hoe = true
		velocity = Vector2.ZERO
		hoe.swing()

func move(delta):
	# get the input strength
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
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
