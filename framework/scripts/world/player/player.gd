#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

# 实例化控件
@onready var player_father:Control = $Father
@onready var player_body:Control = $Father/Body
@onready var player_header:Control = $Father/Header
@onready var player_header_life_value:Label = $Father/Header/LifeValue
@onready var player_header_life:TextureProgressBar = $Father/Header/Life
@onready var player_header_magic:TextureProgressBar = $Father/Header/Magic
@onready var player_nickname:Label = $Father/NickName

# 初始化节点数据
var player_token:String
var player_clothe:AnimatedSprite2D
var player_weapon:AnimatedSprite2D
var player_wing:AnimatedSprite2D
var player_action:String
var player_target_position:Vector2
var player_move_status:bool

# 如果鼠标事件未被其他场景、节点等资源消耗则触发该函数
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if (event.button_index == 1 and event.pressed) or (event.button_index == 2 and event.pressed):
			Action.update_control_status(true)
		else:
			Action.update_control_status(false)

func _ready():
	player_token = get_meta("token")
	# 默认禁用控制
	Action.update_control_status(false)
	# 默认隐藏玩家主体
	player_father.visible = false
	# 更新玩家数据
	update_player_data()
	# 加载玩家数据资源
	loader_player_resources()
	# 玩家默认状态
	#on_action_stop()

func update_player_data():
	# 玩家昵称
	player_nickname.text = Global.get_player_nickname(player_token)
	# 玩家生命值、职业格式化数据
	player_header_life_value.text = Global.get_player_life_career_format(player_token)
	# 玩家生命值百分比
	player_header_life.value = Global.get_player_life_percentage(player_token)
	# 玩家魔法值百分比
	player_header_magic.value = Global.get_player_magic_percentage(player_token)

func loader_player_resources():
	# 加载玩家服饰
	player_clothe = Equipment.get_clothe_resource(player_token)
	player_body.add_child(player_clothe)
	player_body.move_child(player_clothe, 0)
	player_clothe.play()
	# 加载玩家武器
	player_weapon = Equipment.get_weapon_resource(player_token)
	if player_weapon:
		player_body.add_child(player_weapon)
		player_body.move_child(player_weapon, 1)
		player_weapon.play()
	# 加载玩家装饰
	player_wing = Equipment.get_wing_resource(player_token)
	if player_wing:
		player_body.add_child(player_wing)
		player_body.move_child(player_wing, 2)
		player_wing.play()
	# 初始化玩家方向
	Action.update_angle(Global.get_player_angle(player_token))
	# 初始化玩家位置
	position = Global.map_node.get_child(0).map_to_local(Global.get_player_coordinate(Global.get_account_player_token()))
	player_target_position = position
	# 显示玩家主体
	player_father.visible = true

func _physics_process(_delta):
	if player_father.visible:
		# 更新玩家数据
		update_player_data()
		# 更新鼠标位置
		Action.update_mouse_position(get_local_mouse_position())
		# 更新玩家动作
		player_action = Action.get_action()
		player_clothe.animation = player_action
		player_clothe.play()
		if player_weapon:
			player_weapon.animation = player_action
			player_weapon.play()
		if player_wing:
			player_wing.animation = player_action
			player_wing.play()
		# 运动控制
		if (player_action.find("walking") > 0 or player_action.find("running") > 0) and !player_move_status:
			player_move_status = true
			player_target_position = Action.get_target_position(position)
		if position != player_target_position:
			velocity = position.direction_to(player_target_position) * Action.get_speed()
			if position.distance_squared_to(player_target_position) > 5:
				move_and_slide()
			else:
				player_move_status = false
				position = player_target_position
				Action.restore_default_actions()
		else:
			player_move_status = false
			position = player_target_position
			Action.restore_default_actions()
		## 获取窗口的边界
		#var viewport_rect = get_viewport_rect()
		## 获取鼠标的位置
		#var viewport_mouse_position = get_viewport().get_mouse_position()
		## 检查鼠标是否在窗口内
		#if viewport_rect.has_point(viewport_mouse_position):
			## 获取玩家的位置
			#var player_position = position
			## 获取鼠标的位置
			#var mouse_position = get_local_mouse_position()
			## 获取鼠标的角度(以弧度为单位)并捕捉最接近45度的倍数(0,1,2,3,4,-4,-3,-2,-1)，将获取的倍数分别除以45度(0,1,2,3,4,5,6,7)
			#player_angle = wrapi(int(snapped(mouse_position.angle(), PI/4) / (PI/4)), 0, 8)
			## 计算方向向量
			#var direction = Vector2(cos(player_angle * PI/4), sin(player_angle * PI/4))
			#on_switch_layer()
			#if Input.is_action_pressed("walking") or Input.is_action_pressed("running"):
				#if Input.is_action_pressed("walking"):
					#player_action = "walking" 
					#player_action_speed = 70
					#player_step_length = 50
				#if Input.is_action_pressed("running"):
					#player_action = "running"
					#player_action_speed = 160
					#player_step_length = 100
				## 满足条件才能运动
				#if player_action_speed > 0 and mouse_position.length() > 15:
					#player_body.get_child(0).animation = str(player_angle) + "_" + player_action
					#player_body.get_child(0).play()
					#var weapon_id = Player.get_weapon_value()
					#if weapon_id != "000":
						#player_body.get_child(1).animation = str(player_angle) + "_" + player_action
						#player_body.get_child(1).play()
					#var wing_id = Player.get_wing_value()
					#if wing_id != "000":
						#player_body.get_child(2).animation = str(player_angle) + "_" + player_action
						#player_body.get_child(2).play()
					## 目标位置
					#player_target_position = player_position + direction * player_step_length
					## 目标速度
					#velocity = position.direction_to(player_target_position) * player_action_speed
					## 未到达目标位置则运动
					#if position.distance_to(player_target_position) > 0:
						#move_and_slide()
					#else:
						#on_action_stop()
			#if Input.is_action_just_released("walking") or Input.is_action_just_released("running"):
				#on_action_stop()
		#else:
			#on_action_stop()
	#else:
		#on_action_stop()

#func on_switch_layer():
	#var weapon_id = Player.get_weapon_value()
	#if weapon_id != "000":
		#if player_angle == 3 or player_angle == 4 or player_angle == 5:
			#if player_body.get_child(0).name == "Clothe":
				#player_body.move_child(player_body.get_child(1), 0)
		#else:
			#if player_body.get_child(0).name == "Weapon":
				#player_body.move_child(player_body.get_child(1), 0)
#
#func on_action_stop():
	#velocity = Vector2.ZERO
	#player_action_speed = 0
	#velocity = Vector2.ZERO
	#player_action = "stand"
	#player_body.get_child(0).animation = str(player_angle) + "_" + player_action
	#var weapon_id = Player.get_weapon_value()
	#if weapon_id != "000":
		#player_body.get_child(1).animation = str(player_angle) + "_" + player_action
	#var wing_id = Player.get_wing_value()
	#if wing_id != "000":
		#player_body.get_child(2).animation = str(player_angle) + "_" + player_action
