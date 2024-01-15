#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

# 初始化节点数据
var player_angle: int
var player_action: String

func _ready():
	player_angle = 2
	player_action = "stand"
	pass

func _physics_process(_delta):
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
		# 获取玩家的位置
		var player_position = position
		# 获取鼠标的位置
		var mouse_position = get_local_mouse_position()
		# 获取鼠标的角度(以弧度为单位)并捕捉最接近45度的倍数(0,1,2,3,4,-4,-3,-2,-1)
		var angle = snapped(mouse_position.angle(), PI/4) / (PI/4)
		# 将获取的倍数分别除以45度(0,1,2,3,4,5,6,7)
		player_angle = wrapi(int(angle), 0, 8)
		# 计算方向向量
		var direction = Vector2(cos(player_angle * PI/4), sin(player_angle * PI/4))
		# 鼠标左右键按下时触发
		if Input.is_action_pressed("walking") or Input.is_action_pressed("running"):
			# 更新速度
			if Input.is_action_pressed("walking"):
				player_action = "walking"
				# 鼠标左键行走
				speed = 60
			if Input.is_action_pressed("running"):
				player_action = "running"
				# 鼠标左键奔跑
				speed = 100
			if speed > 0:
				# 鼠标位置距离玩家多远才触发
				if mouse_position.length() > 10:
					$Father/Stand.animation = str(player_angle) + "_" + player_action
					velocity = direction.normalized() * speed
					move_and_slide()
		if Input.is_action_just_released("walking") or Input.is_action_just_released("running"):
			speed = 0
			velocity = Vector2.ZERO
			player_action = "stand"
			$Father/Stand.animation = str(player_angle) + "_" + player_action
