extends Node2D

enum Direction {UP, DOWN, LEFT, RIGHT}

var enemy_scene = preload("res://enemy/voidling/Voidling.tscn")
var bigmund_scene = preload("res://enemy/bigmund/Bigmund.tscn")

@onready var sprite : Sprite2D = $Sprite2D
@onready var control : Control = $Control
@onready var button1: Button = $Control/PanelContainer/HBoxContainer/Button
@onready var button2: Button = $Control/PanelContainer/HBoxContainer/Button2
@onready var button3: Button = $Control/PanelContainer/HBoxContainer/Button3
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var ButtonCollision = $Area2D/CollisionShape2D2

@export var direction_to_next = Direction.LEFT

var hovered = false

var option1direction
var option2direction
var option3direction

var option1flowers
var option2flowers
var option3flowers

var option1turrets
var option2turrets
var option3turrets

const MIN_FLOWERS = 1
const MAX_FLOWERS = 3
const MIN_TURRETS = 1
const MAX_TURRETS = 3



# Called when the node enters the scene tree for the first time.
func _ready():
	# roll options
	# roll tile shape
	option1direction = pick_direction()
	option2direction = pick_direction()
	option3direction = pick_direction()
	
	# roll tile flowers
	option1flowers = randi_range(MIN_FLOWERS,MAX_FLOWERS)
	option2flowers = randi_range(MIN_FLOWERS,MAX_FLOWERS)
	option3flowers = randi_range(MIN_FLOWERS,MAX_FLOWERS)
	# roll turret places
	option1turrets = randi_range(MIN_TURRETS,MAX_TURRETS)
	option2turrets = randi_range(MIN_TURRETS,MAX_TURRETS)
	option3turrets = randi_range(MIN_TURRETS,MAX_TURRETS)
	# roll modifier
	# TODO?
	

func pick_direction():
	var r = randi_range(0,2)
	if r == 0:
		return "left"
	elif r == 1:
		return "right"
	elif r == 2:
		return "straight"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered:
		sprite.modulate = Color.BLUE
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) || Input.is_action_just_pressed("interact"):
			interact()
			
	else:
		sprite.modulate = Color.WHITE

func _physics_process(delta):
	# add a check to see if our target would be filled
	check_if_should_go_away()

func check_if_should_go_away():
	var check_x = get_parent().x_coord
	var check_y = get_parent().y_coord
	if direction_to_next == Direction.UP:
		check_y -= 1
	elif direction_to_next == Direction.DOWN:
		check_y += 1
	elif direction_to_next == Direction.LEFT:
		check_x -= 1
	elif direction_to_next == Direction.RIGHT:
		check_x += 1
	var res = Autoload.check_occupied(Vector2i(check_x, check_y))
	if res:
		make_uninteractable()

func make_uninteractable():
	modulate = Color.BLACK
	$Area2D.visible = false

func inform_in_range():
	pass
	#close = true

func inform_out_of_range():
	pass
	#close = false

func hide_control():
	$Control.visible = false

func interact():
	for node in get_tree().get_nodes_in_group("TileAddPoint"):
		node.hide_control()
		
	button1.text = option1direction + "\n" + str(option1flowers) +  " flowers\n" + str(option1turrets) + " turrets\n Cost: 1 Hope"
	button2.text = option2direction + "\n" + str(option2flowers) +  " flowers\n" + str(option2turrets) + " turrets\n Cost: 1 Hope"
	button3.text = option3direction + "\n" + str(option3flowers) +  " flowers\n" + str(option3turrets) + " turrets\n Cost: 1 Hope"
	#audio.play()
	$Control.visible = true

func generate_streight(flowers, turrets):
	var new_tile_x = get_parent().x_coord
	var new_tile_y = get_parent().y_coord
	
	var tile
	
	if direction_to_next == Direction.UP:
		var r = randi_range(0,2)
		if r == 0:
			tile = load("res://tiles/streight/DUStreightTile.tscn").instantiate()
		elif r == 1:
			tile = load("res://tiles/streight/DUStreightTile2.tscn").instantiate()
		else:
			tile = load("res://tiles/streight/DUStreightTile3.tscn").instantiate()
		new_tile_y -= 1

	elif direction_to_next == Direction.DOWN:
		var r = randi_range(0,2)
		if r == 0:
			tile = load("res://tiles/streight/UDStreightTile.tscn").instantiate()
		elif r == 1:
			tile = load("res://tiles/streight/UDStreightTile2.tscn").instantiate()
		else:
			tile = load("res://tiles/streight/UDStreightTile3.tscn").instantiate()
		new_tile_y += 1

	elif direction_to_next == Direction.LEFT:
		var r = randi_range(0,2)
		if r == 0:
			tile = load("res://tiles/streight/RLStreightTile.tscn").instantiate()
		elif r == 1:
			tile = load("res://tiles/streight/RLStreightTile2.tscn").instantiate()
		else:
			tile = load("res://tiles/streight/RLStreightTile3.tscn").instantiate()
		new_tile_x -= 1

	elif direction_to_next == Direction.RIGHT:
		var r = randi_range(0,2)
		if r == 0:
			tile = load("res://tiles/streight/LRStreightTIle.tscn").instantiate()
		elif r == 1:
			tile = load("res://tiles/streight/LRStreightTIle2.tscn").instantiate()
		else:
			tile = load("res://tiles/streight/LRStreightTIle3.tscn").instantiate()
		new_tile_x += 1
	
	tile.x_coord = new_tile_x
	tile.y_coord = new_tile_y
	tile.next_tile_ref = get_parent()
	tile.position = Vector2(new_tile_x * 512, new_tile_y * 512)
	tile.flower_count = flowers
	tile.turret_count = turrets
	
	# this double get parent is brittle, maybe add tiles group?
	Autoload.occupiedTiles.append(Vector2i(new_tile_x, new_tile_y))
	get_parent().get_parent().add_child(tile)

func generate_right_turn(flowers, turrets):
	var new_tile_x = get_parent().x_coord
	var new_tile_y = get_parent().y_coord
	
	var tile
	
	if direction_to_next == Direction.UP:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/URTurnTile.tscn").instantiate() #UPRIGHT
		elif r == 1:
			tile = load("res://tiles/turn/URTurnTile2.tscn").instantiate() #UPRIGHT
		new_tile_y -= 1

	elif direction_to_next == Direction.DOWN:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/DLTurnTile.tscn").instantiate() #DOWNLEFT
		elif r == 1:
			tile = load("res://tiles/turn/DLTurnTile2.tscn").instantiate() #DOWNLEFT
		new_tile_y += 1

	elif direction_to_next == Direction.LEFT:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/RUTurnTile.tscn").instantiate() #RIGHTUP
		elif r == 1:
			tile = load("res://tiles/turn/RUTurnTile2.tscn").instantiate() #RIGHTUP
		new_tile_x -= 1

	elif direction_to_next == Direction.RIGHT:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/LDTurnTile.tscn").instantiate() #LEFTDOWN
		elif r == 1:
			tile = load("res://tiles/turn/LDTurnTile2.tscn").instantiate() #LEFTDOWN
		new_tile_x += 1
	
	tile.x_coord = new_tile_x
	tile.y_coord = new_tile_y
	tile.next_tile_ref = get_parent()
	tile.position = Vector2(new_tile_x * 512, new_tile_y * 512)
	tile.flower_count = flowers
	tile.turret_count = turrets
	
	# this double get parent is brittle, maybe add tiles group?
	Autoload.occupiedTiles.append(Vector2i(new_tile_x, new_tile_y))
	get_parent().get_parent().add_child(tile)

func generate_left_turn(flowers, turrets):
	var new_tile_x = get_parent().x_coord
	var new_tile_y = get_parent().y_coord
	
	var tile
	
	if direction_to_next == Direction.UP:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/ULTurnTile.tscn").instantiate() #UPLEFT
		elif r == 1:
			tile = load("res://tiles/turn/ULTurnTile2.tscn").instantiate() #UPLEFT
		new_tile_y -= 1

	elif direction_to_next == Direction.DOWN:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/DRTurnTile.tscn").instantiate() #DOWNRIGHT
		elif r == 1:
			tile = load("res://tiles/turn/DRTurnTile2.tscn").instantiate() #DOWNRIGHT
		new_tile_y += 1

	elif direction_to_next == Direction.LEFT:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/RDTurnTile.tscn").instantiate() #RIGHTDOWN
		elif r == 1:
			tile = load("res://tiles/turn/RDTurnTile2.tscn").instantiate() #RIGHTDOWN
		new_tile_x -= 1

	elif direction_to_next == Direction.RIGHT:
		var r = randi_range(0,1)
		if r == 0:
			tile = load("res://tiles/turn/LUTurnTile.tscn").instantiate() #LEFTUP
		elif r == 1:
			tile = load("res://tiles/turn/LUTurnTile2.tscn").instantiate() #LEFTUP
		new_tile_x += 1
	
	tile.x_coord = new_tile_x
	tile.y_coord = new_tile_y
	tile.next_tile_ref = get_parent()
	tile.position = Vector2(new_tile_x * 512, new_tile_y * 512)
	tile.flower_count = flowers
	tile.turret_count = turrets
	
	# this double get parent is brittle, maybe add tiles group?
	Autoload.occupiedTiles.append(Vector2i(new_tile_x, new_tile_y))
	get_parent().get_parent().add_child(tile)

func spawn_voidling(delay):
	var enemy = enemy_scene.instantiate()
	enemy.current_tile = get_parent()
	enemy.target_pos = get_parent().give_center_point()
	enemy.global_position = global_position
	enemy.delay = delay
	get_parent().get_parent().get_parent().add_child(enemy)

func spawn_bigmund(delay):
	var enemy = bigmund_scene.instantiate()
	enemy.current_tile = get_parent()
	enemy.target_pos = get_parent().give_center_point()
	enemy.global_position = global_position
	enemy.delay = delay
	get_parent().get_parent().get_parent().add_child(enemy)

func _on_button_pressed():
	for node in get_tree().get_nodes_in_group("TileAddPoint"):
		node.hide_control()
	if Inventory.hopes >= 1:
		generate(option1direction, option1flowers, option1turrets)
		queue_free()
	else:
		$BuzzerAudio.play()

func _on_button_2_pressed():
	for node in get_tree().get_nodes_in_group("TileAddPoint"):
		node.hide_control()
	if Inventory.hopes >= 1:
		generate(option2direction, option2flowers, option2turrets)
		queue_free()
	else:
		$BuzzerAudio.play()

func _on_button_3_pressed():
	for node in get_tree().get_nodes_in_group("TileAddPoint"):
		node.hide_control()
	if Inventory.hopes >= 1:
		generate(option3direction, option3flowers, option3turrets)
		queue_free()
	else:
		$BuzzerAudio.play()

func generate(dir, flowers, turrets):
	Inventory.spend_hope()
	if dir == "left":
		generate_left_turn(flowers, turrets)
	elif dir == "right":
		generate_right_turn(flowers, turrets)
	elif dir == "straight":
		generate_streight(flowers, turrets)

func _on_area_2d_mouse_entered():
	hovered = true

func _on_area_2d_mouse_exited():
	hovered = false
