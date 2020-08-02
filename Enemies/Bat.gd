extends KinematicBody2D

export var FRICTION = 200
export var HURTBOX_KNOCKBACK_MULTIPLIER = 120

var knockback = Vector2.ZERO

onready var stats = $Stats

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	stats.decrease_health(area.damage)
	knockback = area.knockback_vector * HURTBOX_KNOCKBACK_MULTIPLIER

func _on_Stats_no_health():
	queue_free()
