extends Node2D

@onready var label : Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func inform_in_range():
	label.visible = true

func inform_out_of_range():
	label.visible = false

func interact():
	print("get picked idiot")
	Inventory.add_cool_flower()
	queue_free()
