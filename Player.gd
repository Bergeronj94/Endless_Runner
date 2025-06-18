extends CharacterBody2D


const SPEED = 300.0
const DASH = 10
const JUMP_VELOCITY = -400.0

#animation stuff for now
@export var anim: AnimatedSprite2D

#handling jump variables
var can_jump: bool = true

#debug stuff
@export var state_label: Label
#3d stuff
@export var player: Node3D 
#variables for running
var direction: float

#dashing stuff
@export var dashing_timer: Timer

#attacking stuff
@export var attack_timer: Timer
var attack_region: PackedScene
var attack_node: Node



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state: States
var previous_state: States #using this to check whether you need ot emit again
#signals for states
signal state_changed(new_state, delta)

#handles the logic for all the states
enum States {
	IDLE,
	RUNNING,
	JUMPING,
	COLLIDED,
	DEATH,
	FALLING,
	DASHING,
	ATTACKING,
	NOTATTACKING
}

func _ready():
	connect('state_changed', Callable(self, "_on_state_changed"))
	state = States.RUNNING
	emit_signal('state_changed', state, 60)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	match state:
		0: #idle
			velocity = Vector2.ZERO
		1: #running
			velocity.x = move_toward(velocity.x, SPEED, 0.75)
		2: #jumping
			velocity.x = move_toward(velocity.x, SPEED, 0.75)
		5: #falling
			pass
		6: #dashing
			velocity.x += DASH
	if is_on_floor():
		can_jump = true
	#trying to create my own things for input and stuff for running
	if Input.is_action_pressed('right') and is_on_floor():
		emit_signal('state_changed', States.RUNNING, 1.0)
	if Input.is_action_pressed('left') and is_on_floor():
		emit_signal('state_changed', States.RUNNING, -1)
	if Input.is_action_just_pressed('jump') and can_jump == true:
		emit_signal('state_changed', States.JUMPING, delta)
	if Input.is_action_just_pressed("attack") and state != States.ATTACKING:
		emit_signal('state_changed', States.ATTACKING, delta)
	if not is_on_floor() and Input.is_action_just_pressed('dash'):
		emit_signal('state_changed', States.DASHING, delta)
	
	#clamping our velocity before we call move_and_slide
	velocity.x = clamp(velocity.x, 0, 750)
	move_and_slide()

func _on_state_changed(new_state, _delta):
	state_label.text = str(new_state)
	previous_state = state
	state = new_state
	match state:
		0: #IDLE
			anim.play('idle')
		1: #RUNNING
			anim.play('running')
			#player.get_node('AnimationPlayer').play('mixamo_com')
			#player.rotation.y = PI/2
		2: #JUMPING
			#player.get_node('AnimationPlayer').play('Jump/jump')
			anim.play('jumping')
			velocity.y = JUMP_VELOCITY
			can_jump = false
		3: #COLLIDED
			pass
		4: #DEATH
			pass
		5: #FALLING and make sure you += the gravity so the falling because correct
			pass
		6: #DASHING
			anim.play('dashing')
			dashing_timer.start()
		7: #attacking
			attack_region = preload('res://atack_shape.tscn')
			attack_node = attack_region.instantiate()
			add_child(attack_node)
			attack_timer.start()
		8: #not attackig
			remove_child(attack_node)
			emit_signal('state_changed', States.RUNNING, _delta)
			
	move_and_slide()
			
func _on_player_obstacle_collision_detection_body_entered(body):
	if body.is_in_group('obstacles'):
		ScoreTracker.emit_signal('player_crashed')
		emit_signal('state_changed', States.DEATH, 60)


func _on_dashing__timer_timeout():
	emit_signal('state_changed', States.RUNNING, 60)
	dashing_timer.stop()


func _on_attack_timer_timeout() -> void:
	emit_signal('state_changed', States.NOTATTACKING, 60)
	attack_timer.stop()
