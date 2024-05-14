extends Node

@export var x_coord = 0
@export var y_coord = 0
@export var flower_count = 0
@export var turret_count = 0

var next_tile_ref = null

var flower_scene = preload("res://flowers/CoolFlower.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for f in flower_count:
		add_flower()
	for t in turret_count:
		for c in get_children():
			if c.name == "Turret" + str(t+1):
				c.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func give_center_point():
	return $PathCenter.get_global_position()
	
func give_end_point():
	return $PathEnd.get_global_position()

func give_next_tile():
	return next_tile_ref

func add_flower():
	var randx = randf_range(-250.0, 250.0)
	var randy = randf_range(-250.0, 250.0)
	var flower = flower_scene.instantiate()
	flower.position.x = randx
	flower.position.y = randy
	add_child(flower)
	
