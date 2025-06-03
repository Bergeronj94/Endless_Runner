extends Node2D

#for obstacles
@export var player: CharacterBody2D
@export var obstacle_spawn_interval: float = 2.0 # Time in seconds between obstacle spawns
@export var obstacle_spawn_distance: float = 800.0 # Distance in front of the player to spawn the obstacle
@export var obstacle_size: Vector2 = Vector2(10, 30) # Size of the obstacle rectangle
@export var obstacle_collision_layer: int = 2
@export var obstacle_collision_mask: int = 1

var obstacles_array: Dictionary
var player_detection_dictionary: Dictionary


#calculating score
var num_jumps: int

	


func spawn_obstacle():
	var obstacle = StaticBody2D.new()
	get_parent().add_child(obstacle) # Add the obstacle to the game world

	var obstacle_shape = CollisionShape2D.new()
	obstacle_shape.shape = RectangleShape2D.new()
	obstacle.add_child(obstacle_shape)
	obstacle_shape.shape.size = obstacle_size

	obstacle.collision_layer = obstacle_collision_layer
	obstacle.collision_mask = obstacle_collision_mask

	obstacle.global_position = Vector2(player.global_position.x + obstacle_spawn_distance, 0)
	obstacles_array[str(obstacle.global_position.x)] = obstacle 
	obstacle.add_to_group('obstacles')
	
	#var player_detection_area = Area2D.new()
	#obstacle.add_child(player_detection_area)
	
	#var player_detection_shape = CollisionShape2D.new()
	#player_detection_shape.shape = RectangleShape2D.new()
#	player_detection_shape.shape.size = obstacle_size + Vector2(0, 1000)
#	player_detection_area.add_child(player_detection_shape)
#	player_detection_area.global_position = Vector2(player.global_position.x + obstacle_spawn_distance, 0)
	
#	player_detection_area.collision_layer = obstacle_collision_layer
#	player_detection_area.collision_mask = obstacle_collision_mask
	

	
	
	
	
	
	
	
	
func _on_obstacle_spawn_timer_timeout():
	spawn_obstacle()
	score_counter()
	
func score_counter():
	var last_key_array = Array(obstacles_array.keys())
	if len(last_key_array) >= 2:
		if player.global_position.x > float(last_key_array[0]):
			num_jumps += 1
			last_key_array.erase(last_key_array[0])
