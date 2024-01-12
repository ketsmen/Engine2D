#*****************************************************************************
# @file    server.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 自定义信号
signal item_pressed(server_token: String)

# 初始化服务器数据
var server_list: Array = []
var selected_token: String = ""

func _ready():
	selected_token = ""
	server_list = []
	# 显示当前节点场景
	visible = true

func _on_item_pressed():
	item_pressed.emit(selected_token)
