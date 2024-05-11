extends Node2D

enum Direction {UP, DOWN, LEFT, RIGHT}

@onready var label : Label = $Label

@export var direction_to_next = Direction.LEFT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	print(str(res))
	if res:
		queue_free()

func inform_in_range():
	label.visible = true

func inform_out_of_range():
	label.visible = false

func interact():
	print("one new tile comin right up yeppers")
	generate_next_tile()
	queue_free()

func generate_next_tile():
	var pick = randi_range(0,5)
	if pick == 0 or pick == 1:
		#generate a streight
		generate_streight()
	elif pick == 2:
		# generate a left turn
		generate_left_turn()
		pass
	elif pick == 3:
		#generate a right turn
		generate_right_turn()
		pass
	else:
		#generate a fork
		generate_fork()

func generate_streight():
	var new_tile_x = get_parent().x_coord
	var new_tile_y = get_parent().y_coord
	
	var tile
	
	if direction_to_next == Direction.UP:
		tile = load("res://tiles/streight/DUStreightTile.tscn").instantiate()
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
	tile.position = Vector2(new_tile_x * 512, new_tile_y * 512)
	
	# this double get parent is brittle, maybe add tiles group?
	Autoload.occupiedTiles.append(Vector2i(new_tile_x, new_tile_y))
	get_parent().get_parent().add_child(tile)

func generate_right_turn():
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
	tile.position = Vector2(new_tile_x * 512, new_tile_y * 512)
	
	# this double get parent is brittle, maybe add tiles group?
	Autoload.occupiedTiles.append(Vector2i(new_tile_x, new_tile_y))
	get_parent().get_parent().add_child(tile)

func generate_left_turn():
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
	tile.position = Vector2(new_tile_x * 512, new_tile_y * 512)
	
	# this double get parent is brittle, maybe add tiles group?
	Autoload.occupiedTiles.append(Vector2i(new_tile_x, new_tile_y))
	get_parent().get_parent().add_child(tile)

func generate_fork():
	var new_tile_x = get_parent().x_coord
	var new_tile_y = get_parent().y_coord
	var tile
	
	if direction_to_next == Direction.UP:
		tile = load("res://tiles/fork/UpFork.tscn").instantiate()
		new_tile_y -= 1

	elif direction_to_next == Direction.DOWN:
		tile = load("res://tiles/fork/DownFork.tscn").instantiate()
		new_tile_y += 1

	elif direction_to_next == Direction.LEFT:
		tile = load("res://tiles/fork/LeftFork.tscn").instantiate()
		new_tile_x -= 1

	elif direction_to_next == Direction.RIGHT:
		tile = load("res://tiles/fork/RightFork.tscn").instantiate()
		new_tile_x += 1
	
	tile.x_coord = new_tile_x
	tile.y_coord = new_tile_y
	tile.position = Vector2(new_tile_x * 512, new_tile_y * 512)
	
	# this double get parent is brittle, maybe add tiles group?
	Autoload.occupiedTiles.append(Vector2i(new_tile_x, new_tile_y))
	get_parent().get_parent().add_child(tile)
