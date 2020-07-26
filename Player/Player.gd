extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ACCELERATION = 200
const MAX_SPEED = 80
const FRICTION = 250

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var animation: String = "IdleRight"

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
	#print("hello world")

#func moveX():
#	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
#		velocity.x = 0
#	elif Input.is_action_pressed("ui_right"):
#		velocity.x = speed
#	elif Input.is_action_pressed("ui_left"):
#		velocity.x = -speed
#	else: 
#		velocity.x = 0

#func _ready():
#	# $ means part of same scene
#	animationPlayer = $AnimationPlayer


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		#if input_vector.x > 0:
		#	animation = "RunRight"
		#else:
		#	animation = "RunLeft"
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		#animation = "IdleRight"
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# animationPlayer.play(animation)
	velocity = move_and_slide(velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
