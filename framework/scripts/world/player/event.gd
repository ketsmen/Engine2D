extends AnimatedSprite2D

func _on_animation_finished(type: String):
	if type == "clothe":
		var player_action:String = get_parent().get_parent().get_parent().player_action
		if player_action.find("stand") > 0:
			play()
		else:
			Action.restore_default_actions()
