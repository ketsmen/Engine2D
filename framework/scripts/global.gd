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

# 获取玩家昵称
func get_player_nickname_value() -> String:
	return data["world"]["player"]["nickname"]

# 获取玩家职业
func get_player_career_value() -> String:
	return data["world"]["player"]["career"]

# 获取玩家性别
func get_player_gender_value() -> String:
	return data["world"]["player"]["gender"]

# 获取玩家生命值
func get_player_life_value():
	return data["world"]["player"]["asset"]["life"]

func get_player_life_float() -> float:
	return float(data["world"]["player"]["asset"]["life"])

func get_player_life_string() -> String:
	return str(data["world"]["player"]["asset"]["life"])

func get_player_life_percentage() -> float:
	return (float(data["world"]["player"]["asset"]["life"]) / float(data["world"]["player"]["asset"]["life_max"])) * 100

func get_player_life_format_value() -> String:
	return str(data["world"]["player"]["asset"]["life"]) + "/" + str(data["world"]["player"]["asset"]["life_max"])

# 获取玩家魔法值
func get_player_magic_value():
	return data["world"]["player"]["asset"]["magic"]

func get_player_magic_float() -> float:
	return float(data["world"]["player"]["asset"]["magic"])

func get_player_magic_string() -> String:
	return str(data["world"]["player"]["asset"]["magic"])

func get_player_magic_percentage() -> float:
	return (float(data["world"]["player"]["asset"]["magic"]) / float(data["world"]["player"]["asset"]["magic_max"])) * 100

# 更新玩家数据
func on_update_player_data(parameter: String, value):
	if data[parameter]:
		data[parameter] = value
