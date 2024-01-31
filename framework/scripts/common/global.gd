#*****************************************************************************
# @file    global.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 初始化数据结构
var data = {
	"account": {
		"token": "",
		"player_token": "",
		"area": {
			"token": "",
			"list": []
		},
		"role": []
	},
	"player": {},
	"monster": {},
	"npc": {}
}

# 初始化自定义数据
var world_node:Node2D
var map_node:Node2D
var player_node:Node2D
var monster_node:Node2D
var npc_node:Node2D
var player:CharacterBody2D

# 获取账号Token
func get_account_token() -> String:
	return data["account"]["token"]

# 设置账号Token
func set_account_token(token: String):
	data["account"]["token"] = token

# 获取账号服务区Token
func get_account_area_token() -> String:
	return data["account"]["area"]["token"]

# 设置账号服务区Token
func set_account_area_token(token: String):
	data["account"]["area"]["token"] = token

# 获取账号服务区列表
func get_account_area_list() -> Array:
	return data["account"]["area"]["list"]

# 设置账号服务区列表
func set_account_area_list(list: Array):
	data["account"]["area"]["list"] = list

# 获取账号服务区角色信息
func get_account_area_role(index: int):
	return data["account"]["role"][index]
	
# 获取账号服务区角色列表
func get_account_area_role_list() -> Array:
	return data["account"]["role"]

# 设置账号服务区角色列表
func set_account_area_role_list(list: Array):
	data["account"]["role"] = list

# 获取账号的玩家Token
func get_account_player_token() -> String:
	return data["account"]["player_token"]

# 更新并返回账号的玩家Token
func update_account_player_token(token: String) -> String:
	data["account"]["player_token"] = token
	return data["account"]["player_token"]

# 更新玩家数据
func update_player_data(player_data: Dictionary) -> Dictionary:
	data["player"][player_data["token"]] = player_data
	return data["player"][player_data["token"]]

# 获取玩家昵称
func get_player_nickname(token: String) -> String:
	return data["player"][token]["role_nickname"]

# 获取玩家职业
func get_player_career(token: String) -> String:
	return data["player"][token]["role_career"]

# 获取玩家性别
func get_player_gender(token: String) -> String:
	return data["player"][token]["role_gender"]

# 获取玩家角度
func get_player_angle(token: String) -> int:
	return data["player"][token]["role_angle"]
	
# 获取玩家等级
func get_player_level(token: String) -> int:
	return data["player"][token]["role_asset_level"]

# 获取玩家生命值
func get_player_life(token: String) -> int:
	return data["player"][token]["role_asset_life"]

# 获取玩家生命值百分比
func get_player_life_percentage(token: String) -> float:
	return (float(data["player"][token]["role_asset_life"]) / float(data["player"][token]["role_asset_life_max"])) * 100

# 获取玩家生命值格式化数据
func get_player_life_format(token: String) -> String:
	return str(data["player"][token]["role_asset_life"]) + "/" + str(data["player"][token]["role_asset_life_max"])

# 获取玩家生命值与职业格式化数据
func get_player_life_career_format(token: String) -> String:
	var career_level = ""
	if data["player"][token]["role_career"] == "warrior":
		career_level = "/Z" + str(data["player"][token]["role_asset_level"])
	if data["player"][token]["role_career"] == "mage":
		career_level = "/M" + str(data["player"][token]["role_asset_level"])
	if data["player"][token]["role_career"] == "taoist":
		career_level = "/T" + str(data["player"][token]["role_asset_level"])
	return str(data["player"][token]["role_asset_life"]) + "/" + str(data["player"][token]["role_asset_life_max"]) + career_level

# 获取玩家魔法值
func get_player_magic(token: String) -> int:
	return data["player"][token]["role_asset_magic"]

# 获取玩家魔法值百分比
func get_player_magic_percentage(token: String) -> float:
	return (float(data["player"][token]["role_asset_magic"]) / float(data["player"][token]["role_asset_magic_max"])) * 100

# 获取玩家魔法值格式化数据
func get_player_magic_format(token: String) -> String:
	return str(data["player"][token]["role_asset_magic"]) + "/" + str(data["player"][token]["role_asset_magic_max"])

# 获取玩家经验值
func get_player_experience(token: String) -> int:
	return data["player"][token]["role_asset_experience"]

# 获取玩家经验值百分比
func get_player_experience_percentage(token: String) -> float:
	return (float(data["player"][token]["role_asset_experience"]) / float(data["player"][token]["role_asset_experience_max"])) * 100

# 获取玩家地图编号
func get_player_map_id(token: String) -> String:
	return data["player"][token]["role_map"]

# 获取玩家地图名称
func get_player_map_name(token: String) -> String:
	return data["player"][token]["role_map_name"]

# 获取玩家地图资源路径
func get_player_map_path(token: String) -> String:
	return Utils.get_map_root_path() + data["player"][token]["role_map"] + ".tscn"

# 获取玩家服饰
func get_player_clothe_id(token: String) -> String:
	return data["player"][token]["role_body_clothe"]

# 获取玩家服饰资源路径
func get_player_clothe_path(token: String) -> String:
	return Utils.get_clothe_root_path() + data["player"][token]["role_body_clothe"] + "/" + data["player"][token]["role_gender"] + ".tscn"

# 获取玩家武器编号
func get_player_weapon_id(token: String) -> String:
	return data["player"][token]["role_body_weapon"]

# 获取玩家武器资源路径
func get_player_weapon_path(token: String) -> String:
	return Utils.get_weapon_root_path() + data["player"][token]["role_body_weapon"] + "/" + data["player"][token]["role_gender"] + ".tscn"

# 获取玩家翅膀编号
func get_player_wing_id(token: String) -> String:
	return data["player"][token]["role_body_wing"]

# 获取玩家翅膀资源路径
func get_player_wing_path(token: String) -> String:
	return Utils.get_wing_root_path() + data["player"][token]["role_body_wing"] + "/" + data["player"][token]["role_gender"] + ".tscn"

# 获取玩家当前坐标
func get_player_coordinate(token: String) -> Vector2:
	return data["player"][token]["coordinate"]

# 更新并返回玩家当前坐标
func update_player_coordinate(token: String, coordinate: Vector2) -> Vector2:
	data["player"][token]["coordinate"] = coordinate
	return data["player"][token]["coordinate"]
