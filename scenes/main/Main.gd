extends Node2D

onready var ui_play = $UI/Play_UI
onready var player = $YSort/Player
onready var camera = $Camera2D
onready var camera_tween = $Camera2D/Tween
onready var bin = $YSort/Bin

var score = 0

var camera_dimensions = Vector2(160,96)
onready var camera_official_position = camera.position

func _process(delta):
	var curr_camera_test = Vector2(stepify(player.position.x-camera_dimensions.x,camera_dimensions.x*2)+camera_dimensions.x,stepify(player.position.y-camera_dimensions.y,camera_dimensions.y*2)+camera_dimensions.y)
	if !camera_tween.is_active() and camera_official_position != curr_camera_test:
		camera_tween.interpolate_property(camera,"position",camera.position,curr_camera_test,0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		camera_tween.start()
		camera_official_position = curr_camera_test
		get_tree().paused = true
		yield(camera_tween, "tween_completed")
		get_tree().paused = false
		

# Called when the node enters the scene tree for the first time.
func _ready():
	ui_play.set_inventory_max(player.inventory_size)

func _on_Player_got_score(new_score):
	score = new_score
	ui_play.set_score(score)

func _on_Player_got_item(new_item):
	ui_play.set_inventory_curr(player.inventory_list.size())
	ui_play.set_inventory_max(player.inventory_size)

func _on_Player_deposited_in_bin():
	#Play the animation
	bin.play_deposit()
	#Add up all the points 
	var money_gained = 0
	#Set the score variable
	for i in player.inventory_list:
		money_gained += i.item_value
	#Set the points on the UI
	score += money_gained
	ui_play.set_score(score)
	#Clear the player's inventory
	player.inventory_list.clear()
	ui_play.set_inventory_curr(0)
