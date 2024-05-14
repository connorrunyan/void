extends CharacterBody2D

const SPEED = 5000.0

var target_pos
var current_tile
var heading_to_midpoint = true
var arrived_in_center = false

var hit_timer = 1.0
var hit_delay = 1.0

func _physics_process(delta):
	
	var distance_to_center = global_position.distance_to(Vector2(0.0, 0.0))
	if distance_to_center <= 250.0:
		hit_timer -= delta
	
	if hit_timer <= 0.0:
		get_tree().get_first_node_in_group("Van").hit_van(1)
		hit_timer = hit_delay
	# if we have a target pos, see if we're close to it.  if so, get next target
	# if we have a target pos and we're not close to it, move towards it
	if arrived_in_center:
		print("arrived")
		return
	else:
		var distance = global_position.distance_to(target_pos)
		if distance <= 10.0:
			if heading_to_midpoint:
				# we were going to a midpoint, now go to an endpoint
				target_pos = current_tile.give_end_point()
				heading_to_midpoint = false
			else:
				# we were going to an endpoint, get next tile's midpoint
				current_tile = current_tile.next_tile_ref
				print("new tile" + str(current_tile.name))
				if current_tile == null:
					arrived_in_center = true
				else:
					target_pos = current_tile.give_center_point()
					heading_to_midpoint = true
		
		if current_tile != null:
			var xOffset = target_pos.x - global_position.x
			var yOffset = target_pos.y - global_position.y
			var direction = Vector2(xOffset, yOffset).normalized()
			velocity = direction * SPEED * delta
			move_and_slide()
