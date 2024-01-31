extends AnimatedSprite2D

func _on_animation_finished(type: String):
	if type == "clothe":
		var player_node:CharacterBody2D = Global.player
		if player_node.player_action.find("stand") > 0:
			play()
		else:
			if player_node.player_action.find("attack") > 0:
				Action.update_action_name("attack_stand")
				await get_tree().create_timer(1).timeout
			Action.restore_default_actions()
		
