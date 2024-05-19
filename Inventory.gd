extends Node

var cool_flower_count = 0
var hopes = 4

func add_cool_flower():
	cool_flower_count += 1

func spend_cool_flowers(c):
	cool_flower_count -= c

func add_hope():
	hopes += 1

func spend_hope():
	hopes -= 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
