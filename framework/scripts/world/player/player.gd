#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

func _ready():
	pass

func _process(delta):
	# 获取调试控制输入
	if Global.data["debug"]:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * 90
		move_and_slide()
