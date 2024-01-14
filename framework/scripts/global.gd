#*****************************************************************************
# @file    global.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# TODO 后续将从服务端获取、同步数据
var data = {
	"debug": true,
	"config": {
		"version": "1.0.0",
		"user_path": "user://userdata/",
		"map_path": "res://framework/scenes/world/map/"
	},
	"world": {
		"current_map": "001"
	}
}

func _ready():
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))
