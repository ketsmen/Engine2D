#*****************************************************************************
# @file    server.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 自定义信号
signal item_pressed(server_token: String)

# 初始化节点数据
var server_list: Array = []
var selected_token: String = ""

func _ready():
	# 设置节点默认数据
	selected_token = ""
	server_list = []
	# 显示当前节点场景
	visible = true

func _on_item_pressed():
	item_pressed.emit(selected_token)
