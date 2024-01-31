#*****************************************************************************
# @file    equipment.gd
# @author  MakerYang
#*****************************************************************************
extends Node

# 初始化数据结构
var data = {
	"speed_scale": 8
}

# 获取玩家服饰资源
func get_clothe_resource(token: String) -> AnimatedSprite2D:
	var clothe_path = Global.get_player_clothe_path(token)
	var clothe_loader = load(clothe_path).instantiate()
	clothe_loader.name = "Clothe"
	clothe_loader.speed_scale = data["speed_scale"]
	return clothe_loader

# 获取玩家武器资源
func get_weapon_resource(token: String) -> AnimatedSprite2D:
	if Global.get_player_weapon_id(token) == "000":
		return null
	var weapon_path = Global.get_player_weapon_path(token)
	var weapon_loader = load(weapon_path).instantiate()
	weapon_loader.name = "Weapon"
	weapon_loader.speed_scale = data["speed_scale"]
	return weapon_loader

# 获取玩家翅膀装饰资源
func get_wing_resource(token: String) -> AnimatedSprite2D:
	if Global.get_player_wing_id(token) == "000":
		return null
	var wing_path = Global.get_player_wing_path(token)
	var wing_loader = load(wing_path).instantiate()
	wing_loader.name = "Wing"
	wing_loader.speed_scale = data["speed_scale"]
	return wing_loader
