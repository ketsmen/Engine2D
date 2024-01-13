#*****************************************************************************
# @file    roles.gd
# @author  MakerYang
#*****************************************************************************
extends Control

signal return_button_pressed

func _ready():
	modulate = Color(1, 1, 1, 0)
	# 开始游戏按钮允许点击
	$Start/StartButton.disabled = false

func _on_sound_finished():
	# 确保背景音效循环播放
	$Sound.play()

func _on_return_button_pressed():
	return_button_pressed.emit()

func _on_start_button_pressed():
	pass
