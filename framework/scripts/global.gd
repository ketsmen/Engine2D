#*****************************************************************************
# @file    global.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# TODO 后续将从服务端获取、同步数据
var data = {
	"debug": true,
	"is_control": true,
	"config": {
		"version": "1.0.0",
		"user_path": "user://userdata/",
		"map_path": "res://framework/scenes/world/map/",
		"clothe_path": "res://framework/scenes/world/player/clothe/"
	},
	"world": {
		"current_map": "001",
		"player": {
			"nickname": "游戏管理员",
			"career": "warrior",
			"gender": "man",
			"angle": 1,
			"asset": {
				"level": 42,
				"life": 1500,
				"life_max": 1599,
				"magic": 800,
				"magic_max": 1000,
				"experience": 50000,
				"experience_max": 500000,
				"backpack": []
			},
			"body": {
				"clothe": "000",
				"weapon": "000"
			}
		}
	}
}

func _ready():
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))

func on_update_player_data(parameter: String, value):
	if data[parameter]:
		data[parameter] = value
	
