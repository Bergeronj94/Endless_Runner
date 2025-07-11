extends Camera2D


#get the player node for position
@export var player: CharacterBody2D

#shaking the camera or effect
@export var randomStrength: float
@export var shakeFade: float
@export var shake_timer: Timer

var shaking: bool = false
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

#camera limit ray cast points



func _ready(): #these only need to be limited once 
	var ray_top_limit = player.top_limit_ray
	var ray_bottom_limit = player.bottom_limit_ray
	ScoreTracker.connect('obstacle_destroyed', Callable(self, '_shake'))
	ScoreTracker.connect('obstacle_destroyed', Callable(self, '_stop_shake'))
	limit_top = player.top_limit_ray.collision_point.y
	limit_bottom = player.bottom_limit_ray.collision_point.y
	
	
	
func _physics_process(delta: float) -> void:
	#print(shake_strength)
	if shake_strength > 0: #gets the random shaking each frame
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()	
	

func _shake(): #set the strength when triggered by the scoretracker signal
	shake_strength = randomStrength	
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength),rng.randf_range(-shake_strength, shake_strength))


func _on_label_timer_timeout() -> void:
	limit_top = player.top_limit_ray.collision_point.y
	limit_bottom = player.bottom_limit_ray.collision_point.y
