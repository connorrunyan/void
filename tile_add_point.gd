extends Node2D

enum Direction {UP, DOWN, LEFT, RIGHT}

var enemy_scene = preload("res://enemy/voidling/Voidling.tscn")

@onready var sprite : Sprite2D = $Sprite2D
@onready var control : Control = $Control
@onready var button1: Button = $Control/PanelContainer/HBoxContainer/Button
@onready var button2: Button = $Control/PanelContainer/HBoxContainer/Button2
@onready var button3: Button = $Control/PanelContainer/HBoxContainer/Button3
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

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
const MAX_FLOWERS = 10
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
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$Control.visible = false
	
	if Input.is_action_just_pressed("next_wave"):
		add_enemy()

func _physics_process(delta):
	# add a check to see if our target would be filled
	check_if_should_go_away()

func add_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.current_tile = get_parent()
	enemy.target_pos = get_parent().give_center_point()
	enemy.global_position = global_position
	
	get_parent().get_parent().get_parent().add_child(enemy)

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
		queue_free()

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
		
	button1.text = option1direction + "\n" + str(option1flowers) +  " flowers\n" + str(option1turrets) + " turrets\n"
	button2.text = option2direction + "\n" + str(option2flowers) +  " flowers\n" + str(option2turrets) + " turrets\n"
	button3.text = option3direction + "\n" + str(option3flowers) +  " flowers\n" + str(option3turrets) + " turrets\n"
	audio.play()
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
		tile = load("res://tiles/streight/UDStreightTile.tscn").instantiate()
		new_tile_y += 1

	elif direction_to_next == Direction.LEFT:
		tile = load("res://tiles/streight/RLStreightTile.tscn").instantiate()
		new_tile_x -= 1

	elif direction_to_next == Direction.RIGHT:
		tile = load("res://tiles/streight/LRStreightTIle.tscn").instantiate()
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
		tile = load("res://tiles/turn/URTurnTile.tscn").instantiate() #UPRIGHT
		new_tile_y -= 1

	elif direction_to_next == Direction.DOWN:
		tile = load("res://tiles/turn/DLTurnTile.tscn").instantiate() #DOWNLEFT
		new_tile_y += 1

	elif direction_to_next == Direction.LEFT:
		tile = load("res://tiles/turn/RUTurnTile.tscn").instantiate() #RIGHTUP
		new_tile_x -= 1

	elif direction_to_next == Direction.RIGHT:
		tile = load("res://tiles/turn/LDTurnTile.tscn").instantiate() #LEFTDOWN
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
		tile = load("res://tiles/turn/ULTurnTile.tscn").instantiate() #UPLEFT
		new_tile_y -= 1

	elif direction_to_next == Direction.DOWN:
		tile = load("res://tiles/turn/DRTurnTile.tscn").instantiate() #DOWNRIGHT
		new_tile_y += 1

	elif direction_to_next == Direction.LEFT:
		tile = load("res://tiles/turn/RDTurnTile.tscn").instantiate() #RIGHTDOWN
		new_tile_x -= 1

	elif direction_to_next == Direction.RIGHT:
		tile = load("res://tiles/turn/LUTurnTile.tscn").instantiate() #LEFTUP
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

func _on_button_pressed():
	generate(option1direction, option1flowers, option1turrets)
	queue_free()

func _on_button_2_pressed():
	generate(option2direction, option2flowers, option2turrets)
	queue_free()

func _on_button_3_pressed():
	generate(option3direction, option3flowers, option3turrets)
	queue_free()

func generate(dir, flowers, turrets):
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
