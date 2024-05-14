extends StaticBody2D

# Array to keep track of current enemies in range
var current_targets = []
var damagepershot = 2

var hit_timer = 1.0
var hit_delay = 1.0

var lasertime = 0;

static var Turret_count = 0

@onready var line = $Line2D

#For detecting enemies coming into the zone of the tower
func _on_tower_body_entered(body):
	# Check if the body is an enemy
	if "Voidling" in body.name:
		print("Enemy entered: ", body.name, " into tower: ", self.name)
		
		# Add the enemy to the list of current targets
		if body not in current_targets:
			current_targets.append(body)
		

# For detecting enemies leaving into the zone of the tower
func _on_tower_body_exited(body):
	# Check if the body is a voidling
	if "Voidling" in body.name:
		print("Enemy exited: ", body.name, " from tower: ", self.name)
		
		# if the body is within the array remove it.
		if body in current_targets:
			current_targets.erase(body)

# Function to draw the line to the first enemy in the list
func _update_line():
	#Clear any current points
	line.clear_points()
	
	#if there are targets to shoot draw that line.
	if current_targets.size() > 0:
		#This is all done off of Collision shape but it could just as easily be like sprite or something
		var first_target = current_targets[0]
		if first_target.has_node("CollisionShape2D"):
			var enemy_collision_shape = first_target.get_node("CollisionShape2D")
			
			var tower_center = global_position
			
			
			
			# Add points to the line
			# Convert global positions to local positions relative to the line's position
			line.add_point(to_local(tower_center))
			line.add_point(to_local(first_target.global_position))
			

#Function for shooting those voidy boys
func damage(delta):
	#if there is a target to shoot at, then shoot at him
	if current_targets.size() > 0:
		#reduce the timer by the amount of time that has passed
		hit_timer -= delta
		#If you can hit, enable the laser and deal the damage
		if hit_timer <= 0.0:
			lasertime = 0.2
			hit_timer = hit_delay
			current_targets[0].take_damage(damagepershot)

# Called every frame
func _process(delta):
	#if you can laser, draw the laser
	if(lasertime > 0):
		_update_line()
		lasertime -= delta
	else:
		#clean up the previous lser.
		line.clear_points()
	damage(delta)

static func get_next_turret_name() -> String:
	Turret_count += 1
	return "Turret" + str(Turret_count)

#func _ready():
	# Assign a unique name to this instance
	#self.name = get_next_turret_name()

