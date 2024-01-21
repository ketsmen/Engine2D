#*****************************************************************************
# @file    roles.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var sound:AudioStreamPlayer = $Sound
@onready var create:Control = $Node/Create
@onready var list:Control = $Node/List
@onready var start:Control = $Start
@onready var start_button:TextureButton = $Start/StartButton
@onready var right:Control = $Right
@onready var right_create_button:TextureButton = $Right/CreateButton
@onready var right_restore_button:TextureButton = $Right/RestoreButton
@onready var right_delete_button:TextureButton = $Right/DeleteButton

# 自定义信号
signal return_button_pressed
signal start_button_pressed

# 初始化节点数据
var right_type:String = "list"

func _ready():
	# 隐藏当前节点场景
	modulate.a = 0
	# 默认隐藏节点
	start.visible = false
	create.visible = false
	list.visible = false
	# 暂时禁用角色恢复按钮
	right_restore_button.disabled = true

func _process(_delta):
	# 界面显示检测
	if right_type == "create":
		right_delete_button.disabled = true
		right_create_button.button_pressed = true
		list.visible = false
		start.visible = false
		create.visible = true
	else:
		right_delete_button.disabled = true
		right_create_button.button_pressed = false
		create.visible = false
		if len(User.get_role_list()) > 0:
			right_delete_button.disabled = false
			start.visible = true
			list.visible = true
		if len(User.get_role_list()) >= 6:
			right_create_button.visible = false

func _on_sound_finished():
	# 确保背景音效循环播放
	sound.play()

func _on_return_button_pressed():
	# 返回登录界面
	right_type = "list"
	create.current_gender = 0
	create.current_career = 0
	return_button_pressed.emit()

func _on_start_button_pressed():
	# 开始游戏按钮被点击
	start_button_pressed.emit()

func _on_create_button_pressed():
	right_type = "create"
	
func _on_create_cancel_button_pressed():
	right_type = "list"
