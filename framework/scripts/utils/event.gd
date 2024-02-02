#*****************************************************************************
# @file    event.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 初始化数据结构
var data = {
	"key": "",
	"button": ""
}

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			data["key"] = event.as_text_keycode()
		else:
			data["key"] = ""
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			data["button"] = "left"
		elif event.button_index == 2 and event.pressed:
			data["button"] = "right"
		else:
			data["button"] = ""
# 获取KEY值
func get_key() -> String:
	return data["key"]

# 获取BUTTON值
func get_button() -> String:
	return data["button"]
