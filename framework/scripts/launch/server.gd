#*****************************************************************************
# @file    server.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var server_list_box:VBoxContainer = $Main/ListBox/List

# 自定义信号
signal item_pressed(token: String)

# 初始化节点数据
var server_list: Array = []
var selected_token: String = ""

func _ready():
	# 设置节点默认数据
	selected_token = User.get_area_token_value()
	server_list = User.get_area_list()
	# 显示当前节点场景
	visible = true

func update_server():
	server_list = User.get_area_list()
	# 渲染服务器列表
	var font_path = load("res://framework/statics/fonts/msyh.ttc")
	var texture_normal = load("res://framework/statics/scenes/launch/server/server_button_0.png")
	var texture_pressed = load("res://framework/statics/scenes/launch/server/server_button_1.png")
	var texture_hover = load("res://framework/statics/scenes/launch/server/server_button_2.png")
	for i in range(len(server_list)):
		var item:TextureButton = TextureButton.new()
		var item_label:Label = Label.new()
		item.texture_normal = texture_normal
		item.texture_pressed = texture_pressed
		item.texture_hover = texture_hover
		item_label.text = server_list[i]["area_name"]
		item_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		item_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		item_label.layout_mode = 1
		item_label.anchors_preset = PRESET_CENTER
		item_label["theme_override_font_sizes/font_size"] = "12"
		item_label["theme_override_colors/font_color"] = Color("#cba368")
		item_label["theme_override_fonts/font"] = font_path
		item.add_child(item_label)
		item.connect("pressed", _on_item_pressed.bind(server_list[i]["token"]))
		server_list_box.add_child(item)

func _on_item_pressed(token: String):
	item_pressed.emit(token)
