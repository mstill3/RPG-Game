extends Node2D

export var MAX_HEALTH = 5
onready var health = MAX_HEALTH setget set_health

signal no_health

func set_health(amount):
	health = amount
	if(health <= 0):
		emit_signal("no_health")
	
func decrease_health(amount):
	set_health(health - amount)
	
func increase_health(amount):
	health += amount

func reset_health():
	health = MAX_HEALTH
