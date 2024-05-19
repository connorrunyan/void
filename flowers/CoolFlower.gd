extends Node2D

var hovered = false
var close = false

var interactable_type = "flower"

var pick_audio_scene = preload("res://flowers/FlowerPickSound.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered or close:
		modulate = Color.SKY_BLUE
		if Input.is_action_just_pressed("interact") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			interact()
	else:
		modulate = Color.WHITE
	


func inform_in_range():
	close = true

func inform_out_of_range():
	close = false

func interact():
	var s = pick_audio_scene.instantiate()
	get_parent().add_child(s)
	Inventory.add_cool_flower()
	queue_free()


func _on_area_2d_mouse_entered():
	hovered = true


func _on_area_2d_mouse_exited():
	hovered = false
