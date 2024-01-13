#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

func _ready():
	pass

func _process(_delta):
	# 获取调试控制输入
	if Global.data["debug"]:
		# 获取窗口的边界
		var viewport_rect = get_viewport_rect()
		# 获取鼠标的位置
		var viewport_mouse_position = get_viewport().get_mouse_position()
		# 默认速度
		var speed = 0
		# 检查鼠标是否在窗口内
		if viewport_rect.has_point(viewport_mouse_position):
			if Input.is_action_pressed("walking"):
				speed = 45
			if Input.is_action_pressed("running"):
				speed = 80
			if speed > 0:
				# 获取玩家的位置
				var player_position = position
				var mouse_position = get_local_mouse_position()
				var angle = snapped(mouse_position.angle(), PI/4) / (PI/4)
				angle = wrapi(int(angle), 0, 8)
				if mouse_position.length() > 10:
					velocity = mouse_position.normalized() * speed
					move_and_slide()
