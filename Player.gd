extends CharacterBody2D


var SPEED: float
var DASH: float
var JUMP_VELOCITY: float
var MAXSPEED:float

#camera stuff for raycasting limits
@export var top_limit_ray: RayCast2D
@export var bottom_limit_ray: RayCast2D

#animation stuff for now
@export var anim: AnimatedSprite2D

#handling jump variables
var can_jump: bool = true
@export var jump_timer: Timer

#debug stuff
@export var state_label: Label
#3d stuff
@export var player: Node3D 

#variables for running
var direction: float
var previous_direction: Array

#dashing stuff
@export var dashing_timer: Timer
var can_dash: bool

#attacking stuff
@export var attack_right_pos: Node2D
@export var attack_left_pos: Node2D
@export var attack_timer: Timer
var attack_region: PackedScene
var attack_node: Node
var can_attack: bool = true

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
	var VectorSPEED = attack_left_pos.position.distance_to(attack_right_pos.position)
	SPEED = VectorSPEED * 2
	DASH = VectorSPEED 
	MAXSPEED = SPEED * 3.5
	JUMP_VELOCITY = -SPEED
	print(SPEED, '\n',DASH, '\n', MAXSPEED, '\n', JUMP_VELOCITY)
	connect('state_changed', Callable(self, "_on_state_changed"))
	state = States.IDLE
	emit_signal('state_changed', state, 60)
	
func _physics_process(delta):
	if (state != States.DASHING and state != States.JUMPING) and is_on_floor() == false:
		emit_signal('state_changed', States.FALLING, delta)
		velocity.y += gravity #* delta
	match state:
		0: #idle
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		1: #running
			direction = Input.get_axis('left', 'right')
			match direction:
				-1.0: #step values should always be positive
					velocity.x = move_toward(velocity.x, -SPEED, (SPEED * delta * 2))
				1.0:
					velocity.x = move_toward(velocity.x, SPEED, (SPEED * delta * 2))
		2: #jumping
			velocity.x = move_toward(velocity.x, SPEED, delta)
		5: #falling
			pass
		6: #dashing
			print('dashing in physics')
			velocity.x += direction * DASH
			velocity.y = 0
	if is_on_floor():
		can_dash = true
		can_jump = true
		emit_signal('state_changed', States.RUNNING, -1.0)
	#trying to create my own things for input and stuff for running
	if Input.is_action_pressed('right') and is_on_floor():
		emit_signal('state_changed', States.RUNNING, 1.0)
	if Input.is_action_pressed('left') and is_on_floor():
		emit_signal('state_changed', States.RUNNING, -1.0)
	if Input.is_action_pressed('jump') and can_jump == true: #trying to modify this to jump while you want toa maximum
		emit_signal('state_changed', States.JUMPING, delta)
	if Input.is_action_just_released('jump') and is_on_floor() == false:
		emit_signal('state_changed', States.FALLING, delta)
	if Input.is_action_just_pressed("attack") and state != States.ATTACKING and can_attack == true:
		emit_signal('state_changed', States.ATTACKING, delta)
	if Input.is_action_just_pressed('dash') and can_dash == true:
		emit_signal('state_changed', States.DASHING, delta)
	if Input.is_anything_pressed() == false and state != States.FALLING and state != States.JUMPING and state != States.DASHING and direction == 0.0:
		emit_signal('state_changed', States.IDLE, delta)
	
	#clamping our velocity before we call move_and_slide
	velocity.x = clamp(velocity.x, -MAXSPEED, MAXSPEED)
	move_and_slide()

func _on_state_changed(new_state, _delta):
	state_label.text = str(new_state)
	previous_state = state
	state = new_state
	match state:
		0: #IDLE #used for attacking
			anim.play('idle')
		1: #RUNNING
			if direction != 0.0:
				previous_direction.append(direction)
			match direction:
				-1.0:
					anim.flip_h = true
					anim.play('running')
				1.0:
					anim.flip_h = false
					anim.play('running')
		2: #JUMPING
			jump_timer.start()
			anim.play('jumping')
			velocity.y = JUMP_VELOCITY
			can_jump = false
		3: #COLLIDED
			pass
		4: #DEATH
			pass
		5: #FALLING and make sure you += the gravity so the falling because correct
			anim.play('falling')
		6: #DASHING
			can_dash = false
			match direction:
				-1.0:
					anim.flip_h = true
					anim.play('dashing')
				1.0:
					anim.flip_h = false
					anim.play('dashing')
			dashing_timer.start()
		7: #attacking
			can_attack = false #set this so you can't spawn another attack until the other is gone
			attack_region = preload('res://atack_shape.tscn')
			attack_node = attack_region.instantiate()
			add_child(attack_node)
			#code to make sure the attack shows in the right place
			attack_node.position = attack_right_pos.position
			if len(previous_direction) > 0: #we do this to check for if the previous direction was faced so we attack in teh right direction
				match previous_direction[-1]:
					1.0:
						attack_node.position = attack_right_pos.position
					-1.0:
						attack_node.position = attack_left_pos.position
			match direction:
				-1.0:
					attack_node.position = attack_left_pos.position
				1.0:
					attack_node.position = attack_right_pos.position
			attack_timer.start()
		8: #not attackig
			can_attack = true
			remove_child(attack_node)
			emit_signal('state_changed', States.RUNNING, _delta)
			
func _on_player_obstacle_collision_detection_body_entered(body):
	if body.is_in_group('obstacles'):
		ScoreTracker.emit_signal('player_crashed')
		emit_signal('state_changed', States.DEATH, 60)


func _on_dashing_timer_timeout():
	emit_signal('state_changed', States.FALLING, 60)
	dashing_timer.stop()
	velocity.x = direction * SPEED


func _on_attack_timer_timeout() -> void:
	emit_signal('state_changed', States.NOTATTACKING, 60)
	attack_timer.stop()


func _on_jump_tmer_timeout() -> void:
	if state != States.DASHING: #OTHERWISE WE GET AN IMMEDIATE FALL TO THE GROUND EVEN WHEN DASHING
		emit_signal('state_changed', States.FALLING, 60)
