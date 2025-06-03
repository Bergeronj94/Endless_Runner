extends CanvasLayer

#simple stuff for debugging and assigning variables
@export var player: CharacterBody2D
@export var position: Label
@export var speed: Label
@export var jumps: Label
@export var obstacle_spawner: Node2D


#list of obstacles
var obstacles_array: Dictionary

#assign variables
var can_debug: bool

func _physics_process(delta):
	if Input.is_action_pressed('pause'):
		get_tree().paused = true
	elif Input.is_action_just_released('pause'):
		get_tree().paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if player != null:
		can_debug = true

func _on_label_timer_timeout():
	match can_debug:
		true:
			position.text = str(player.position)
			speed.text = str(player.velocity)
			jumps.text = str(obstacle_spawner.num_jumps)
	
