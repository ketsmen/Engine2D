extends AnimatedSprite2D

func _on_animation_finished(type: String):
	play()
	#if type == "clothe":
		#var action = Action.get_action()
		#if action == "stand":
			#play()
		#if action == "attack":
			#Action.update_action("attack_stand")
			#await get_tree().create_timer(1).timeout
		#Action.update_action("stand")
