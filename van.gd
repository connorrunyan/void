extends Node2D

var max_health = 250
var health = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(health) + " / " + str(max_health)

func hit_van(dmg):
	health -= dmg
	$AudioStreamPlayer2D.play()
	if health <= 0:
		get_tree().change_scene_to_file("res://title.tscn")
