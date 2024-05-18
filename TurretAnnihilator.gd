extends TOWER

class_name AnnihilatorTower

var DPS = 0.1
var laser_time = false

var on_cooldown = false 

@onready var Cooldown = $Timer

func _init_turret():
	print("Laser Turret Initialized")

func compare_health(a, b):
	return a.health < b.health

func _on_tower_body_entered(body):
	if "Voidling" in body.name:
		if body not in current_targets:
			current_targets.append(body)
			current_targets.sort_custom(compare_health)

func _on_tower_body_exited(body):
	if "Voidling" in body.name:
		if body in current_targets:
			current_targets.erase(body)

func _ready():
	damage_per_shot = 3
	_init_turret() 
	print(global_position)

func damage(delta):
	if current_targets.size() > 0 and not on_cooldown:
		laser_time = true
		var target = current_targets[0]
		var damage_this_frame = DPS * delta
		target.take_damage(damage_this_frame)
		if target.health <= 0:
			laser_time = false
			current_targets.erase(target)  # Remove target if it's dead
			initiate_cooldown()  # Start cooldown if a target is killed

func _update_line():
	line.clear_points()
	if current_targets.size() > 0 and laser_time:
		var first_target = current_targets[0]
		line.add_point(to_local(global_position))
		line.add_point(to_local(first_target.global_position))

func _process(delta):
	if laser_time:
		_update_line()
	else:
		line.clear_points()
	if current_targets.size() == 0:
		laser_time = false
	damage(delta)

func initiate_cooldown():
	on_cooldown = true
	laser_time = false
	Cooldown.start()
	await Cooldown.timeout
	on_cooldown = false
