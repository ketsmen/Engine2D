extends AnimatedSprite2D

func _on_animation_finished(type: String):
	play()
	if type == "clothe":
		pass
