extends Node2D

func create_grass_effect():
	# pull class (scene)
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	# create instance from class (scence)
	var grassEffect = GrassEffect.instance()
	
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position 


func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
