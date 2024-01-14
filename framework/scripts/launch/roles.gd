#*****************************************************************************
# @file    roles.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 自定义信号
signal return_button_pressed
signal start_button_pressed

func _ready():
	# 隐藏当前节点场景
	modulate = Color(1, 1, 1, 0)
	# 开始游戏按钮允许点击
	$Start/StartButton.disabled = false

func _on_sound_finished():
	# 确保背景音效循环播放
	$Sound.play()

func _on_return_button_pressed():
	# 恢复人物状态
	$Character.current_gender = 0
	$Character.current_career = 0
	return_button_pressed.emit()

func _on_start_button_pressed():
	# 开始游戏按钮被点击
	start_button_pressed.emit()
