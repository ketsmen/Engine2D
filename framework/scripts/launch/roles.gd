#*****************************************************************************
# @file    roles.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var sound:AudioStreamPlayer = $Sound
@onready var start:Control = $Start
@onready var start_button:TextureButton = $Start/StartButton
@onready var create:Control = $Node/Create
@onready var list:Control = $Node/List

# 自定义信号
signal return_button_pressed
signal start_button_pressed

func _ready():
	# 隐藏当前节点场景
	modulate.a = 0
	# 默认隐藏节点
	start.modulate.a = 1
	create.modulate.a = 0
	list.modulate.a = 0
	# 开始游戏按钮不允许点击
	start_button.disabled = false

func _on_sound_finished():
	# 确保背景音效循环播放
	sound.play()

func _on_return_button_pressed():
	# 恢复人物状态
	create.current_gender = 0
	create.current_career = 0
	return_button_pressed.emit()

func _on_start_button_pressed():
	# 开始游戏按钮被点击
	start_button_pressed.emit()
