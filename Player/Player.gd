extends KinematicBody2D


export var ACCELERATION = 200
export var MAX_SPEED = 90
export var ROLL_SPEED = 120
export var FRICTION = 350

enum {
	MOVE,
	ATTACK,
	ROLL
}

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var animation: String = "IdleRight"
var state = MOVE
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox


func _ready():
#	stats.connect("no_health")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector


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
		swordHitbox.knockback_vector = roll_vector
		
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
	velocity = velocity * 0.80
	state = MOVE
