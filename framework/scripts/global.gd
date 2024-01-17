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
		"map_root_path": "res://framework/scenes/world/map/",
		"clothe_path": "res://framework/scenes/world/player/clothe/"
	},
	"world": {
		"current_map": "001",
		"player": {
			"nickname": "游戏管理员",
			"career": "warrior",
			"gender": "women",
			"angle": 1,
			"asset": {
				"level": 42,
				"life": 1500,
				"life_max": 1599,
				"magic": 800,
				"magic_max": 1000,
				"experience": 250000,
				"experience_max": 500000,
				"backpack": []
			},
			"body": {
				"clothe": "011",
				"weapon": "000"
			}
		}
	}
}

func _ready():
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))

# 设置玩家是否可以控制
func set_player_control(status: bool):
	data["is_control"] = status

# 地图根路径
func get_map_root_path() -> String:
	return data["config"]["map_root_path"]

# 获取玩家所在地图
func get_player_current_map() -> String:
	return data["config"]["map_root_path"] + data["world"]["current_map"] + ".tscn"

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

func get_player_life_percentage() -> float:
	return (float(data["world"]["player"]["asset"]["life"]) / float(data["world"]["player"]["asset"]["life_max"])) * 100

func get_player_life_format_value() -> String:
	return str(data["world"]["player"]["asset"]["life"]) + "/" + str(data["world"]["player"]["asset"]["life_max"])

# 获取玩家魔法值
func get_player_magic_value():
	return data["world"]["player"]["asset"]["magic"]

func get_player_magic_percentage() -> float:
	return (float(data["world"]["player"]["asset"]["magic"]) / float(data["world"]["player"]["asset"]["magic_max"])) * 100

# 获取玩家经验值
func get_player_experience_value():
	return data["world"]["player"]["asset"]["experience"]

# 获取玩家最大经验值
func get_player_experience_max_value():
	return data["world"]["player"]["asset"]["experience_max"]

# 获取玩家经验条数据
func get_player_experience(page: int) -> Array:
	var bar_states = []
	# 每个子节点代表的经验值量
	var exp_per_bar = int(data["world"]["player"]["asset"]["experience_max"]) / page
	# 计算当前经验值对应的子节点索引
	var active_bar_index = int(int(data["world"]["player"]["asset"]["experience"]) / exp_per_bar)
	var remainder_exp = int(data["world"]["player"]["asset"]["experience"]) % exp_per_bar
	# 计算
	for i in range(page):
		var state = {"visible": false, "value": 0}
		if i < active_bar_index:
			state["visible"] = true
			state["value"] = 100
		elif i == active_bar_index:
			state["visible"] = true
			state["value"] = (float(remainder_exp) / float(exp_per_bar)) * 100
		else:
			state["visible"] = false
			state["value"] = 0
		bar_states.append(state)
	return bar_states

# 更新玩家数据
func on_update_player_data(parameter: String, value):
	if data[parameter]:
		data[parameter] = value
