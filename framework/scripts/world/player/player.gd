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
		# 默认步长，将影响玩家最终的走位
		var step_length = 10
		# 检查鼠标是否在窗口内
		if viewport_rect.has_point(viewport_mouse_position):
			if Input.is_action_pressed("walking"):
				# 鼠标左键行走
				speed = 40
			if Input.is_action_pressed("running"):
				# 鼠标左键奔跑
				speed = 80
			if speed > 0:
				# 获取玩家的位置
				var player_position = position
				# 获取鼠标的位置
				var mouse_position = get_local_mouse_position()
				# 获取鼠标的角度(以弧度为单位)并捕捉最接近45度的倍数(0,45,90,135,180,-135,-90,-45)
				var angle = snapped(mouse_position.angle(), PI/4) / (PI/4)
				# 将获取的倍数分别除以45度(0,1,2,3,4,-3,-2,-1)
				angle = wrapi(int(angle), 0, 8)
				# 鼠标位置距离玩家多远才触发
				if mouse_position.length() > 5:
					var direction = mouse_position.normalized()
					# TODO 需要增加步长控制，将影响玩家最终的走位
					#var new_position = player_position + direction * step_length
					#position = new_position
					velocity = direction * speed
					move_and_slide()
