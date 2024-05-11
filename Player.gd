extends Node2D

const SPEED = 300.0
const INTERACT_DISTANCE = 50.0

@onready var camera = $Camera2D
@onready var label = $Label
@onready var pick_audio = $PickAudioStreamPlayer
@onready var new_tile_audio = $NewTileAudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_movement(delta)
	handle_camera_movmement(delta)
	handle_interactables(delta)
	
	# update label
	label.text = str(Inventory.cool_flower_count)
	
func handle_movement(delta):
	# movement
	var dx = 0.0
	var dy = 0.0
	if Input.is_action_pressed("ui_left"):
		dx -= 1.0
	if Input.is_action_pressed("ui_right"):
		dx += 1.0
	if Input.is_action_pressed("ui_up"):
		dy -= 1.0
	if Input.is_action_pressed("ui_down"):
		dy += 1.0
	var offset = Vector2(dx, dy) * SPEED * delta
	position += offset

func handle_camera_movmement(delta):
	#camera movement
	var target_camera_pos = global_position
	if Input.is_action_pressed("ui_accept"):
		target_camera_pos = ((global_position * 5) + (get_global_mouse_position() * 4)) / 9
	camera.global_position = lerp(camera.global_position, target_camera_pos, 4 * delta)

func handle_interactables(delta):
	var want_to_interact = Input.is_action_just_pressed("interact")
	
	var interactables = get_tree().get_nodes_in_group("Interactable")
	for i in interactables:
		var iPos = i.global_position
		var distance = global_position.distance_to(iPos)
		if distance <= INTERACT_DISTANCE:
			i.inform_in_range()
			if want_to_interact:
				i.interact()
				pick_audio.play() # TODO differentiate audio
		else:
			i.inform_out_of_range()
