#*****************************************************************************
# @file    user.gd
# @author  MakerYang
#*****************************************************************************
extends Node

var data = {
	"token": "",
	"area": {
		"token": "",
		"list": []
	},
	"role": []
}

# 获取用户Token
func get_token_value() -> String:
	return data["token"]

# 设置用户Token
func set_token_value(token: String):
	data["token"] = token

# 获取服务区Token
func get_area_token_value() -> String:
	return data["area"]["token"]

# 设置服务区Token
func set_area_token_value(token: String):
	data["area"]["token"] = token

# 获取服务区列表
func get_area_list() -> Array:
	return data["area"]["list"]

# 设置服务区列表
func set_area_list(list: Array):
	data["area"]["list"] = list

# 获取角色列表
func get_role(index: int):
	return data["role"][index]
	
# 获取角色列表
func get_role_list() -> Array:
	return data["role"]

# 设置角色列表
func set_role_list(list: Array):
	data["role"] = list
