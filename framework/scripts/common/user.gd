#*****************************************************************************
# @file    user.gd
# @author  MakerYang
#*****************************************************************************
extends Node

var data = {
	"token": "",
	"areas": []
}

# 获取用户Token
func get_token_value() -> String:
	return data["token"]
