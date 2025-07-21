extends Node2D

@export var left_move_point: Node2D
@export var right_move_point: Node2D
var starting_position: Vector2
var SPEED: float
@export var left_ledge_ray: RayCast2D
@export var right_ledge_ray: RayCast2D



func _ready():
	starting_position = position
	SPEED = left_move_point.position.distance_to(right_move_point.position)
	
func _physics_process(delta: float) -> void:
	move_platform(delta)
	check_ray_casts()
	
func move_platform(delta):
	position = position.move_toward(left_move_point.position, delta)
	if position.distance_to(left_move_point.position) < 20:
		position.move_toward(right_move_point.position, delta)
	if position.distance_to(right_move_point.position) < 20:
		position.move_toward(left_move_point.position, delta)
		
func check_ray_casts():
	if left_ledge_ray.is_colliding() == true:
		if left_ledge_ray.get_collider().is_in_group('player') and Input.is_action_pressed("jump"):
			left_ledge_ray.get_collider().position = left_ledge_ray.global_position
	elif right_ledge_ray.is_colliding() == true:
		if right_ledge_ray.get_collider().is_in_group('player') and Input.is_action_pressed('jump'):
			right_ledge_ray.get_collider().position = right_ledge_ray.global_position
		
