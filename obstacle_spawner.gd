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


#calculating score and randomizing the spawn_distance and intervals
var num_jumps: int
var random = RandomNumberGenerator.new()

	
func _on_obstacle_spawn_timer_timeout(): #this is where the game actually randomizes the stuff and spawns the timers
	#randomize_distance_interval()
	#spawn_obstacle()
	#score_counter()
	pass
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


func randomize_distance_interval():
	obstacle_spawn_distance = random.randi_range(400, 1200)
	obstacle_spawn_interval = randf_range(1, 7)
	
func score_counter(): #change this to just counting the frames passed and divide by delta
	pass
			
