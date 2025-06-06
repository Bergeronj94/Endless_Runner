extends CanvasLayer

#simple stuff for debugging and assigning variables
@export var player: CharacterBody2D
@export var position: Label
@export var speed: Label
@export var jumps: Label
@export var obstacle_spawner: Node2D
@export var Pause: VBoxContainer


#list of obstacles
var obstacles_array: Dictionary

#assign variables
var can_debug: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if player != null:
		can_debug = true
	Pause.hide()
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed('pause') and player.state != 4: #only allow pausing when the player isn't dead so you can't pul the pause menu over the end level screen
		Pause.show()
		get_tree().paused = true

func _on_label_timer_timeout():
	match can_debug:
		true:
			position.text = str(player.position)
			speed.text = str(player.velocity)
			jumps.text = str(ScoreTracker.score)
	
#signals for handling the pause menu
func _on_quit_pressed():
	get_tree().paused = false
	ScoreTracker.load_scene('Start_Menu')


func _on_reset_pressed():
	var _reload = get_tree().reload_current_scene()
	get_tree().paused = false
	


func _on_resume_pressed():
	get_tree().paused = false
	Pause.hide()
