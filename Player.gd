extends CharacterBody2D


const SPEED = 300.0
const DASH = 10
const JUMP_VELOCITY = -400.0

#handling jump variables
var can_jump: bool = true

#dashing stuff
@export var dashing_timer: Timer
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
	DASHING
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
	if Input.is_action_just_pressed('jump') and can_jump == true:
		emit_signal('state_changed', States.JUMPING, delta)
	if not is_on_floor() and Input.is_action_just_pressed('dash'):
		emit_signal('state_changed', States.DASHING, delta)
	
	#clamping our velocity before we call move_and_slide
	velocity.x = clamp(velocity.x, 0, 750)
	move_and_slide()

func _on_state_changed(new_state, _delta):
	previous_state = state
	state = new_state
	match state:
		0: #IDLE
			pass
		1: #RUNNING
			pass
		2: #JUMPING
			velocity.y = JUMP_VELOCITY
			can_jump = false
		3: #COLLIDED
			pass
		4: #DEATH
			pass
		5: #FALLING and make sure you += the gravity so the falling because correct
			pass
		6: #DASHING
			dashing_timer.start()
			
	move_and_slide()
			

func _on_player_obstacle_collision_detection_body_entered(body):
	if body.is_in_group('obstacles'):
		ScoreTracker.emit_signal('player_crashed')
		emit_signal('state_changed', States.DEATH, 60)
		


func _on_dashing__timer_timeout():
	emit_signal('state_changed', States.RUNNING, 60)
	dashing_timer.stop()
