#*****************************************************************************
# @file    dialog.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 初始化节点数据
var Message:Control = Control.new()
var Message_Content:Label = Label.new()

func on_message(content: String, duration: int):
	var root = get_tree().get_root()
	if !Message.is_inside_tree():
		var font_path = load("res://framework/statics/fonts/msyh.ttc")
		var message_background:TextureRect = TextureRect.new()
		message_background.texture = load("res://framework/statics/scenes/common/message_background.png")
		Message_Content.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		Message_Content.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		Message_Content.size = Vector2(222, 54)
		Message_Content.add_theme_font_size_override("font_size", 12)
		Message_Content.add_theme_color_override("font_color", Color("#ffffff"))
		Message_Content.add_theme_font_override("font", font_path)
		message_background.add_child(Message_Content)
		Message.anchor_left = 0.5
		Message.anchor_right = 0.5
		Message.anchor_top = 0.01
		Message.size = Vector2(222, 54)
		Message.offset_left = -111
		Message.add_child(message_background)
		root.add_child(Message)
	Message_Content.text = content
	Message.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	if duration == 0:
		duration = 2
	tween.tween_property(Message, "modulate:a", 0, 0.5).set_delay(duration)
