extends KinematicBody2D

var velocity = Vector2.ZERO

const MAX_SPEED = 50
const ACCELERATION = 500
const FRICTION = 500

#Variable holds a list of all areas the player is touching
var touching_list_crops = []

#Score storage? Not sure it's a good idea to have this here, but it'll work for now I suppose.
var score = 0

func _process(delta):
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
	
	if Input.is_action_just_pressed("action_interact") and !touching_list_crops.empty():
		harvest_closest_touching_crop()

#Harvest the nearest crop
func harvest_closest_touching_crop():
	#If the list is empty
	if touching_list_crops.empty():
		#Say so and exit the function
		print("touching_list_crops is empty!")
		return
	#Variables for tracking results from the for loop
	var closest_crop = null
	var closest_distance = null
	#For each crop
	for i in touching_list_crops:
		#Get the distance between the player and crop
		var curr_distance = global_position.distance_to(i.owner.global_position)
		#If the previous number is beat
		if closest_crop == null or closest_distance == null or curr_distance < closest_distance:
			#Save the new one
			closest_crop = i
			closest_distance = curr_distance
	#Increment the score by the crop's worth and call the crop's built in "harvest" function
	var received_points = closest_crop.owner.harvest()
	score += received_points

#When an area is entered
func _on_Area2D_area_entered(area):
	#If the owner of the area touched is in the "crop" group
	if area.owner.is_in_group("crop"):
		#Add it to the list
		touching_list_crops.append(area)
		
#When an area is exited
func _on_Area2D_area_exited(area):
	#If the owner of the area touched area's owner is null (due to being deleted) or is in the "crop" group
	if area.owner == null or area.owner.is_in_group("crop"):
		#Remove if from the list
		touching_list_crops.erase(area)
