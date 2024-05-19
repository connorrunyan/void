extends StaticBody2D

@onready var control : Control = $Control
@onready var button1: Button = $Control/PanelContainer/HBoxContainer/Button
@onready var button2: Button = $Control/PanelContainer/HBoxContainer/Button2
@onready var button3: Button = $Control/PanelContainer/HBoxContainer/Button3
@onready var sprite = $TowerBody
#@onready var ButtonCollision = $Area2D/CollisionShape2D2

var LaserTowerScene = preload("res://TurretLaser.tscn")
var BombTowerScene = preload("res://TurretBomber.tscn")
var AnnihilatorTowerScene = preload("res://TurretAnnihilator.tscn")

var hovered = false

var current_turret = null

func _init_turret():
	print("Tower Base initialised")

func interact():
	for node in get_tree().get_nodes_in_group("Turret"):
		if node.has_method("hide_control"):
			node.hide_control()
	button1.text = "LASER\nCost: 1 Flower"
	button2.text = "BOMBER\nCost: 2 Flowers"
	button3.text = "ANNIHILATOR\nCost: 2 Flowers"
	$Control.visible = true
	#ButtonCollision.disabled = false

func hide_control():
	$Control.visible = false

func _ready(): 
	_init_turret() 

func _process(delta):
	if hovered:
		sprite.modulate = Color.BLUE
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) || Input.is_action_just_pressed("interact"):
			interact()
	else:
		sprite.modulate = Color.SEA_GREEN
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#$Control.visible = false
			#ButtonCollision.disabled = true

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
	for node in get_tree().get_nodes_in_group("Turret"):
		if node.has_method("hide_control"):
			node.hide_control()
	if Inventory.cool_flower_count >= 1:
		Inventory.spend_cool_flowers(1)
		swap_turret(LaserTowerScene)
	else:
		$AudioStreamPlayer.play()

func _on_button_2_pressed():
	for node in get_tree().get_nodes_in_group("Turret"):
		if node.has_method("hide_control"):
			node.hide_control()
	if Inventory.cool_flower_count >= 2:
		Inventory.spend_cool_flowers(2)
		swap_turret(BombTowerScene)
	else:
		$AudioStreamPlayer.play()

func _on_button_3_pressed():
	for node in get_tree().get_nodes_in_group("Turret"):
		if node.has_method("hide_control"):
			node.hide_control()
	if Inventory.cool_flower_count >= 2:
		Inventory.spend_cool_flowers(2)
		swap_turret(AnnihilatorTowerScene)
	else:
		$AudioStreamPlayer.play()
