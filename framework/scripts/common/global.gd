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
	},
	"source": ""
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

# 验证邮箱格式
func check_mail_format(mail:String) -> bool:
	var check:bool = true
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$")
	if !regex.search(mail):
		check = false
	return check

# 获取当前时间
func get_current_time() -> String:
	var current_time = Time.get_time_dict_from_system()
	var hour = current_time.hour
	var minute = current_time.minute
	var second = current_time.second
	if hour < 10:
		hour = "0" + str(hour)
	if minute < 10:
		minute = "0" + str(minute)
	if second < 10:
		second = "0" + str(second)
	return str(hour) + ":" + str(minute) + ":" + str(second)
