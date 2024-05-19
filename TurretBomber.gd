# LaserTower.gd
extends TOWER

class_name BomberTower

var BombScene = preload("res://Bullet1.tscn")

func _init_turret():
	print("Bomber Turret Initialized")

func _ready():
	damage_per_shot = 14.0 
	hit_delay = 2.5   
	_init_turret() 
	print(global_position)

func fireBomb():
	var bomb = BombScene.instantiate()
	add_child(bomb)
	bomb.start(to_local(global_position), to_local(current_targets[0].global_position), damage_per_shot)

func damage(delta):
	if current_targets.size() > 0:
		hit_timer -= delta
		if hit_timer <= 0.0:
			hit_timer = hit_delay
			fireBomb()

func _process(delta):
	damage(delta)
	face_target()

func face_target():
	if current_targets.size() >= 1:
		$Node2D.look_at(current_targets[0].global_position)
