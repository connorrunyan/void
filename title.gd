extends Control

@onready var anim = $AnimationPlayer
@onready var label = $Intro/VBoxContainer3/VBoxContainer/Label

var chars = 0
var timer = 0.1
var char_delay = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	Autoload.set_music_calm()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0.0:
		timer = char_delay
		chars += 1
		label.visible_characters = chars

#continue past text
func _on_button_pressed():
	anim.play("fade_to_menu")

# play
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Game.tscn")

#options
func _on_button_2_pressed():
	pass # Replace with function body.

#quit
func _on_button_3_pressed():
	pass # Replace with function body.


