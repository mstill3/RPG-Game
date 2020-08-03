extends AnimatedSprite

func _on_HitEffect_ready():
	playing = true

func _on_HitEffect_animation_finished():
	queue_free()
