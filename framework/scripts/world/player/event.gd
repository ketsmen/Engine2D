extends AnimatedSprite2D

func _on_animation_finished(type: String):
	if type == "clothe":
		var player_node:CharacterBody2D = get_parent().get_parent().get_parent()
		if player_node.player_action.find("stand") > 0:
			play()
