#*****************************************************************************
# @file    dialog.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var message:Control = $Message
@onready var message_content:Label = $Message/TextureRect/Label

func _ready():
	message.modulate.a = 0
	message.visible = false

func show_message(content: String, duration: int):
	message_content.text = content
	message.modulate.a = 1
	message.visible = true
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	if duration == 0:
		duration = 2
	tween.tween_property(message, "modulate:a", 0, 0.5).set_delay(duration)
