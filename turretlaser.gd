# LaserTower.gd
extends TOWER

class_name LaserTower

var laser_duration = 0.4  # How long the laser is visible
var damage_per_tick  # Damage applied each frame the laser is visible
var laser_time = 0

func _init_turret():
	print("Laser Turret Initialized")

func _ready():
	damage_per_shot = 4  
	hit_delay = 1.0    
	_init_turret() 
	print(global_position)

func damage(delta):
	if current_targets.size() > 0:
		hit_timer -= delta
		if hit_timer <= 0.0:
			laser_time = laser_duration
			hit_timer = hit_delay
			damage_per_tick = damage_per_shot / (laser_duration / delta)  # Calculate damage per tick
			_update_line()
		elif laser_time > 0:
			current_targets[0].take_damage(damage_per_tick)
			laser_time -= delta

func _update_line():
	line.clear_points()
	if current_targets.size() > 0 and laser_time > 0:
		var first_target = current_targets[0]
		line.add_point(to_local(global_position))
		line.add_point(to_local(first_target.global_position))

func _process(delta):
	if laser_time > 0:
		_update_line()
	else:
		line.clear_points()
	damage(delta)
