extends AudioStreamPlayer

var high_score = 0

var calm_music = preload("res://Equatorial Complex.mp3")
var fight_music = preload("res://Burn The World Waltz .mp3")

var occupiedTiles: Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_occupied(Vector2i(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_music_calm():
	stop()
	stream = calm_music
	play(0.0)

func set_music_fight():
	stop()
	stream = fight_music
	play(0.0)

func add_occupied(v:Vector2i):
	occupiedTiles.append(v)

func submit_high_score(s):
	high_score = s

func check_occupied(v:Vector2i):
	var result = false
	for t : Vector2i in occupiedTiles:
		if t.x == v.x and t.y == v.y:
			result = true
	return result
