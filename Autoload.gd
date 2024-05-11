extends Node

var occupiedTiles: Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_occupied(Vector2i(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_occupied(v:Vector2i):
	occupiedTiles.append(v)

func check_occupied(v:Vector2i):
	var result = false
	for t : Vector2i in occupiedTiles:
		if t.x == v.x and t.y == v.y:
			result = true
	return result
