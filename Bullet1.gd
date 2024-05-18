extends CharacterBody2D

var speed = 1.5
var target_pos = Vector2()
var damage
var arrived = false
var ShadowDisplacement = 150 

@onready var ExplosionRadius = $Area2D
@onready var ExplosionSprite = $Kaboom
@onready var ExploTimer = $Timer
@onready var BombSprite =$Sprite2D
@onready var ShadowSprite = $Shadow


func start(start_position, end_position, Kaboominess):
	position = start_position
	target_pos = end_position
	damage = Kaboominess
	ShadowSprite.position = Vector2(0, ShadowDisplacement)
	
func update_shadow():
	var distance_ratio = position.distance_to(target_pos) / (global_position - target_pos).length()
	ShadowSprite.position.y = lerp(0, ShadowDisplacement, distance_ratio)
	
	# Adjust shadow's scale to decrease as it gets closer
	var scale_factor = lerp(0.05, 0.6, distance_ratio) 
	ShadowSprite.scale = Vector2(scale_factor, scale_factor)

func _process(delta):
	var direction = (target_pos - position.normalized())
	if arrived == false:
		position += direction * speed * delta
		update_shadow()
	if position.distance_to(target_pos) < 1 && arrived == false:
		arrived = true
		kaboom()

func show_explosion():
	BombSprite.visible = false
	ShadowSprite.visible = false
	ExplosionSprite.visible = true
	#schedule the sprite to hide
	ExploTimer.start()

#remember the alamo
func kaboom():
	show_explosion()
	for body in ExplosionRadius.get_overlapping_bodies():
		if "Voidling" in body.name:
			body.take_damage(damage) 
	await ExploTimer.timeout
	self.queue_free()
