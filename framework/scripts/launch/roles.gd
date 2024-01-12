#*****************************************************************************
# @file    roles.gd
# @author  MakerYang
#*****************************************************************************
extends Control

func _ready():
	modulate = Color(1, 1, 1, 0)

func _on_sound_finished():
	# 确保背景音效循环播放
	$Sound.play()
