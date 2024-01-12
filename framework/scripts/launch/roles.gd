#*****************************************************************************
# @file    roles.gd
# @author  MakerYang
#*****************************************************************************
extends Control

func _ready():
	$Background.modulate = Color(1, 1, 1, 1)

func _on_sound_finished():
	# 确保背景音效循环播放
	$Sound.play()
