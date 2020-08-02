extends KinematicBody2D


const ACCELERATION = 200
const MAX_SPEED = 90
const ROLL_SPEED = 120
const FRICTION = 350

enum {
	MOVE,
	ATTACK,
	ROLL
}

var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
var animation: String = "IdleRight"
var state = MOVE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")


func _physics_process(delta):
	match(state):
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
	 
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		
		roll_vector = input_vector
		
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = ROLL
	
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	move()
	#var input_vector = animationTree.get("parameters/Roll/blend_position")
	#velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	animationState.travel("Roll")
	
	
func move():
	velocity = move_and_slide(velocity)
	
	
func finish_attack_animation():
	state = MOVE

func finish_roll_animation():
	state = MOVE
