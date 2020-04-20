extends Node2D

onready var ui_play = $UI/Play_UI
onready var player = $YSort/Player
onready var camera = $Camera2D
onready var camera_tween = $Camera2D/Tween
onready var bin = $YSort/Bin
onready var ground_tilemap = $TileMap2
onready var farmland_parent = $YSort/Farmland

export var farmland:PackedScene

var score = 0
var unlocked_gates_count = 0
var gate_prices = [100,200,400,700,1000,1500,2000]

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
	ui_play.set_inventory_max(player.sellable_size)

func _on_Player_got_score(new_score):
	score = new_score
	ui_play.set_score(score)

func _on_Player_got_item(new_item):
	ui_play.set_inventory_curr(player.sellable_list.size())
	ui_play.set_inventory_max(player.sellable_size)

func _on_Player_deposited_in_bin(item):
	#Play the animation
	bin.play_deposit()
	#Add up all the points 
	var money_gained = 0
	#Set the score variable
	money_gained += item.item_value
	#Set the points on the UI
	score += money_gained
	ui_play.set_score(score)
	ui_play.set_inventory_curr(player.sellable_list.size())

func _on_Player_swung_tool(impact_pos):
	var tile_coord = ground_tilemap.world_to_map(impact_pos)
	var tile = ground_tilemap.get_cellv(tile_coord)
	if tile == 1:
		var new_farmland = farmland.instance()
		farmland_parent.add_child(new_farmland)
		new_farmland.global_position = Vector2(stepify(impact_pos.x-8,16)+8,stepify(impact_pos.y-8,16)+8)

func _on_Player_scrolled_inventory(item):
	if item == null:
		ui_play.set_equipped(null)
	else:
		ui_play.set_equipped(item.item_icon)

func _on_Player_unlocked_gate():
	unlocked_gates_count += 1
	ui_play.display_gate_message(unlocked_gates_count)

func _on_Player_is_touching_fence(is_touching_fence):
	if is_touching_fence:
		ui_play.display_gate_message(unlocked_gates_count)
		ui_play.show_message()
	else:
		ui_play.hide_message()

func _on_Player_interact_gate(gate):
	if score >= gate_prices[unlocked_gates_count]:
		score -= gate_prices[unlocked_gates_count]
		ui_play.set_score(score)
		unlocked_gates_count += 1
		gate.open_gate()

func _on_Player_is_touching_vending(is_touching,vending):
	if is_touching:
		ui_play.display_message(vending.ui_price)
		ui_play.show_message()
	else:
		ui_play.hide_message()

func _on_Player_interact_vending(vending):
	if score >= vending.price:
		score -= vending.price
		ui_play.set_score(score)
		vending.activate()
		match vending.drop_type:
			vending.TYPE.NONE:
				pass
			vending.TYPE.SPEED_FERT:
				player.equip_speed_fert()
			vending.TYPE.QUALITY_FERT:
				player.equip_quality_fert()
			vending.TYPE.HOE:
				player.equip_hoe()

func _on_Player_swung_speed_fertilizer(touched_farmland):
	touched_farmland.upgrade_speed()

func _on_Player_swung_quality_fertilizer(touched_farmland):
	touched_farmland.upgrade_quality()
