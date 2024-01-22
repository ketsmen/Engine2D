#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends Node

var data = {
	"token": "",
	"nickname": "游戏管理员",
	"career": "warrior",
	"gender": "men",
	"angle": 2,
	"map": "001",
	"asset": {
		"level": 42,
		"life": 1500,
		"life_max": 1599,
		"magic": 800,
		"magic_max": 1000,
		"experience": 490000,
		"experience_max": 500000,
		"backpack": [],
		"skill": []
	},
	"body": {
		"clothe": "010",
		"weapon": "034",
		"wing": "010",
	}
}

# 获取玩家Token
func get_token() -> String:
	return data["token"]

# 获取玩家昵称
func get_nickname_value() -> String:
	return data["nickname"]

# 获取玩家职业
func get_career_value() -> String:
	return data["career"]

# 获取玩家性别
func get_gender_value() -> String:
	return data["gender"]

# 获取玩家角度
func get_angle_value() -> int:
	return data["angle"]

# 获取玩家地图
func get_map_value() -> String:
	return data["map"]

# 获取玩家地图资源
func get_map() -> String:
	return Global.get_map_root_path() + get_map_value() + ".tscn"

# 获取玩家服饰
func get_clothe_value() -> String:
	return data["body"]["clothe"]
	
# 获取玩家服饰资源
func get_clothe() -> String:
	return Global.get_clothe_root_path() + get_clothe_value() + "/" + get_gender_value() + ".tscn"

# 获取玩家武器
func get_weapon_value() -> String:
	return data["body"]["weapon"]

# 获取玩家武器资源
func get_weapon() -> String:
	return Global.get_weapon_root_path() + get_weapon_value() + "/" + get_gender_value() + ".tscn"

# 获取玩家翅膀
func get_wing_value() -> String:
	return data["body"]["wing"]

# 获取玩家翅膀资源
func get_wing() -> String:
	return Global.get_wing_root_path() + get_wing_value() + "/" + get_gender_value() + ".tscn"

# 获取玩家生命值
func get_life_value() -> int:
	return data["asset"]["life"]

# 获取玩家生命值百分比
func get_life_percentage() -> float:
	return (float(data["asset"]["life"]) / float(data["asset"]["life_max"])) * 100

# 获取玩家生命值格式化数据
func get_life_format() -> String:
	return str(data["asset"]["life"]) + "/" + str(data["asset"]["life_max"])

# 获取玩家魔法值
func get_magic_value() -> int:
	return data["asset"]["magic"]

# 获取玩家魔法值百分比
func get_magic_percentage() -> float:
	return (float(data["asset"]["magic"]) / float(data["asset"]["magic_max"])) * 100

# 获取玩家魔法值格式化数据
func get_magic_format() -> String:
	return str(data["asset"]["magic"]) + "/" + str(data["asset"]["magic_max"])

# 获取玩家经验值
func get_experience_value() -> int:
	return data["asset"]["experience"]

# 获取玩家经验条数据
func get_experience(page: int) -> Array:
	var bar_states = []
	# 每个子节点代表的经验值量
	var exp_per_bar = float(data["asset"]["experience_max"]) / page
	# 计算当前经验值对应的子节点索引
	var active_bar_index = int(int(data["asset"]["experience"]) / exp_per_bar)
	var remainder_exp = int(data["asset"]["experience"]) % int(exp_per_bar)
	# 计算每个子节点数据
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
