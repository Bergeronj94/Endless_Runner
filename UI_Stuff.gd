extends CanvasLayer

#simple stuff for debugging and assigning variables
@export var player: CharacterBody2D
@export var position: Label
@export var speed: Label
@export var jumps: Label
@export var dash: Label
@export var attack: Label
@export var obstacle_spawner: Node2D
@export var Pause: VBoxContainer


#labels for abilities
var dash_time: float #player.dashing_timer calls the node
var attack_time: float #player.attack_timer calls the node
#list of obstacles
var obstacles_array: Dictionary

#assign variables
var can_debug: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if player != null:
		can_debug = true
	Pause.hide()
	#dash.text = 'dash: ' + str(player.dashing_timer.get_time_left())
	#attack.text ='attack: ' +  str(player.attack_timer.get_time_left())
	
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed('pause') and player.state != 4: #only allow pausing when the player isn't dead so you can't pul the pause menu over the end level screen
		Pause.show()
		get_tree().paused = true
	dash.text = 'dash: ' + str(player.dashing_timer.get_time_left())
	attack.text ='attack: ' +  str(player.attack_timer.get_time_left())

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
	ScoreTracker.reset()

func _on_reset_pressed():
	get_tree().paused = false
	ScoreTracker.reset()
	var _reload = get_tree().reload_current_scene()
	
func _on_resume_pressed():
	get_tree().paused = false
	Pause.hide()
