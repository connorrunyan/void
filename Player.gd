extends Node2D

const SPEED = 300.0
const INTERACT_DISTANCE = 50.0

@onready var camera = $Camera2D
@onready var label = $CanvasLayer/UI/PanelContainer/HBoxContainer/VBoxContainer/FlowerLabel
@onready var pick_audio = $PickAudioStreamPlayer
@onready var new_tile_audio = $NewTileAudioStreamPlayer

var mortar_timer = 0.0
var mortar_cooldown = 45.0
var railgun_timer = 0.0
var railgun_cooldown = 150.0
@onready var mortar_timer_label = $CanvasLayer/UI/PanelContainer/HBoxContainer/PanelContainer/VBoxContainer/MortarTimerLabel
@onready var railgun_timer_label = $CanvasLayer/UI/PanelContainer/HBoxContainer/PanelContainer2/VBoxContainer/RailgunTimerLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_movement(delta)
	handle_camera_movmement(delta)
	handle_interactables(delta)
	handle_cooldowns(delta)
	
	# update label
	label.text = " Flowers: " + str(Inventory.cool_flower_count) + " "

func handle_cooldowns(delta):
	if mortar_timer <= 0.0:
		# mortar ready
		mortar_timer_label.text = "READY"
		if Input.is_action_just_pressed("mortar"):
			# TODO fire mortar at cursor
			mortar_timer = mortar_cooldown
			mortar_timer_label.text = str("%.2f" % mortar_timer)
	else:
		mortar_timer -= delta
		mortar_timer_label.text = str("%.2f" % mortar_timer)
	
	if railgun_timer <= 0.0:
		railgun_timer_label.text = "READY"
		if Input.is_action_just_pressed("railgun"):
			# TODO fire railgun at target
			railgun_timer = railgun_cooldown
			railgun_timer_label.text = str("%.2f" % railgun_timer)
	else:
		railgun_timer -= delta
		railgun_timer_label.text = str("%.2f" % railgun_timer)


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
	if Input.is_action_pressed("aim"):
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
		else:
			i.inform_out_of_range()
