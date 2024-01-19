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
	}
}

# 获取用户Token
func get_token_value() -> String:
	return data["token"]

# 获取服务区Token
func get_area_token_value() -> String:
	return data["area"]["token"]

# 获取服务区列表
func get_area_list() -> Array:
	return data["area"]["list"]
