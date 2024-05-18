extends StaticBody2D

@onready var control : Control = $Control
@onready var button1: Button = $Control/PanelContainer/HBoxContainer/Button
@onready var button2: Button = $Control/PanelContainer/HBoxContainer/Button2
@onready var button3: Button = $Control/PanelContainer/HBoxContainer/Button3
@onready var sprite = $TowerBody

var LaserTowerScene = preload("res://TurretLaser.tscn")
var BombTowerScene = preload("res://TurretBomber.tscn")

var hovered = false

var current_turret = null

func _init_turret():
	print("Tower Base initialised")

func interact():
	for node in get_tree().get_nodes_in_group("TurretBase"):
		node.hide_control()
		
	button1.text = "LASER"
	button2.text = "BOMBER"
	button3.text = "3"
	$Control.visible = true

func _ready(): 
	_init_turret() 

func _process(delta):
	if hovered:
		sprite.modulate = Color.BLUE
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) || Input.is_action_just_pressed("interact"):
			interact()
	else:
		sprite.modulate = Color.SEA_GREEN
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			$Control.visible = false

func swap_turret(newTurretScene):
	# Instantiates the new turret
	var newTurret = newTurretScene.instantiate()
	
	get_parent().add_child(newTurret)
	newTurret.global_position = global_position  

	
	queue_free()


func _on_area_2d_mouse_entered():
	hovered = true


func _on_area_2d_mouse_exited():
	hovered = false


func _on_button_pressed():
	swap_turret(LaserTowerScene)

func _on_button_2_pressed():
	swap_turret(BombTowerScene)

func _on_button_3_pressed():
	pass # Replace with function body.
