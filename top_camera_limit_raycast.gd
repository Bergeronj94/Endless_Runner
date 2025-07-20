extends RayCast2D

var collider: Node
var collision_point: Vector2
func _ready():
	collision_point = get_collision_point()
	
func _physics_process(delta: float) -> void:
	return_collision_position()
	
func return_collision_position():
	if collider != null:
		collision_point = get_collision_point()


func _on_ray_cast_check_timeout() -> void:
	collider = get_collider()
