#*****************************************************************************
# @file    global.gd
# @author  MakerYang
#*****************************************************************************
extends Node

var data = {
	"debug": true,
	"config": {
		"version": "1.0.0",
		"user_path": "user://userdata/",
		"map_root_path": "res://framework/scenes/world/map/",
		"clothe_root_path": "res://framework/scenes/world/player/clothe/",
		"weapon_root_path": "res://framework/scenes/world/player/weapon/",
		"wing_root_path": "res://framework/scenes/world/player/wing/"
	}
}

func _ready():
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))

# 地图根路径
func get_map_root_path() -> String:
	return data["config"]["map_root_path"]

# 服饰根路径
func get_clothe_root_path() -> String:
	return data["config"]["clothe_root_path"]

# 武器根路径
func get_weapon_root_path() -> String:
	return data["config"]["weapon_root_path"]

# 翅膀根路径
func get_wing_root_path() -> String:
	return data["config"]["wing_root_path"]
