# BaseTower.gd
extends StaticBody2D

class_name TOWER

var current_targets = []
var damage_per_shot = 2
var hit_timer = 1.0
var hit_delay = 1.0

static var Turret_count = 0

@onready var line = $Line2D



func _on_tower_body_entered(body):
	if "Voidling" in body.name:
		if body not in current_targets:
			current_targets.append(body)

func _on_tower_body_exited(body):
	if "Voidling" in body.name:
		if body in current_targets:
			current_targets.erase(body)

func _update_line():
	line.clear_points()
	if current_targets.size() > 0:
		var first_target = current_targets[0]
		if first_target.has_node("CollisionShape2D"):
			line.add_point(to_local(global_position))
			line.add_point(to_local(first_target.global_position))

func damage(delta):
	pass

static func get_next_turret_name() -> String:
	Turret_count += 1
	return "Turret" + str(Turret_count)
