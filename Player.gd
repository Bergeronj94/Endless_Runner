extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state: States
#signals for states
signal state_changed(new_state)



#handles the logic for all the states
enum States {
	IDLE,
	RUNNING,
	JUMPING,
	COLLIDED,
	DEATH
}

func _ready():
	connect('state_changed', Callable(self, "_on_state_changed"))
	state = States.RUNNING
	emit_signal('state_changed', state)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed('jump') and is_on_floor():
		emit_signal('state_changed', States.JUMPING)
	

	move_and_slide()

func _on_state_changed(new_state):
	state = new_state
	match state:
		0: #IDLE
			velocity = Vector2.ZERO
		1: #RUNNING
			velocity.x = SPEED
		2: #JUMPING
			velocity.y = JUMP_VELOCITY
		3: #COLLIDED
			pass
		4: #DEATH
			get_tree().quit()
	move_and_slide()
			
		



func _on_player_obstacle_collision_detection_body_entered(body):
	if body.is_in_group('obstacles'):
		get_tree().quit()
