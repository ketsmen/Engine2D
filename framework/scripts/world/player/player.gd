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
				var mouse_position = get_global_mouse_position()
				# 计算方向向量
				var relative_mouse_position = mouse_position - player_position
				var angle = atan2(relative_mouse_position.y, relative_mouse_position.x)
				# 将角度转换为八个方向之一
				if angle >= -PI/8 and angle < PI/8: # 右
					Input.action_release("ui_up")
					Input.action_release("ui_down")
					Input.action_release("ui_left")
					Input.action_press("ui_right")
				elif angle >= PI/8 and angle < 3*PI/8: # 右下
					Input.action_release("ui_up")
					Input.action_press("ui_down")
					Input.action_release("ui_left")
					Input.action_press("ui_right")
				elif angle >= 3*PI/8 and angle < 5*PI/8: # 下
					Input.action_release("ui_up")
					Input.action_press("ui_down")
					Input.action_release("ui_left")
					Input.action_release("ui_right")
				elif angle >= 5*PI/8 and angle < 7*PI/8: # 左下
					Input.action_release("ui_up")
					Input.action_press("ui_down")
					Input.action_press("ui_left")
					Input.action_release("ui_right")
				elif angle >= -7*PI/8 and angle < -5*PI/8: # 左上
					Input.action_press("ui_up")
					Input.action_release("ui_down")
					Input.action_press("ui_left")
					Input.action_release("ui_right")
				elif angle >= -5*PI/8 and angle < -3*PI/8: # 上
					Input.action_press("ui_up")
					Input.action_release("ui_down")
					Input.action_release("ui_left")
					Input.action_release("ui_right")
				elif angle >= -3*PI/8 and angle < -PI/8: # 右上
					Input.action_press("ui_up")
					Input.action_release("ui_down")
					Input.action_release("ui_left")
					Input.action_press("ui_right")
				else: # 左
					Input.action_release("ui_up")
					Input.action_release("ui_down")
					Input.action_press("ui_left")
					Input.action_release("ui_right")
				var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
				velocity = direction * speed
				move_and_slide()
