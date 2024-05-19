extends Node2D

@onready var timer = $Timer

var voidling_scene = preload("res://enemy/voidling/Voidling.tscn")

var wave_count = 0
var timer_delay = 10

var in_combat = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var timeLeft = timer.time_left
	get_tree().get_first_node_in_group("Player").update_timer_label(wave_count, timeLeft)
	
	var enemy_count = get_tree().get_nodes_in_group("Enemy").size()
	if enemy_count <= 0:
		if in_combat:
			# in combat but leaving it, swap to calm ost
			Autoload.set_music_calm()
			in_combat = false
		else:
			# no enemies but out of combat
			pass
	else:
		#non zero enemy count
		if in_combat:
			# do nothing, in combat w enemies
			pass
		else:
			Autoload.set_music_fight()
			in_combat = true

func spawn_wave(num):
	Inventory.add_hope()
	var add_points = get_tree().get_nodes_in_group("TileAddPoint")
	var num_voidlings = ( 3 * num ) + 2
	var num_bigmunds = num/5
	for i in num_voidlings:
		for point in add_points:
			point.spawn_voidling(i/2.0)
	for i in num / 5:
		for point in add_points:
			point.spawn_bigmund(i)

func _on_timer_timeout():
	# go to next wave, start spawning it
	wave_count += 1
	timer_delay += 3
	timer.wait_time = timer_delay
	spawn_wave(wave_count)
	timer.start()
