#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

# 实例化控件
@onready var sound:AudioStreamPlayer = $Sound
@onready var player_father:Control = $Father
@onready var player_body:Control = $Father/Body
@onready var player_header:Control = $Father/Header
@onready var player_header_life_value:Label = $Father/Header/LifeValue
@onready var player_header_life:TextureProgressBar = $Father/Header/Life
@onready var player_header_magic:TextureProgressBar = $Father/Header/Magic
@onready var player_nickname:Label = $Father/NickName

# 初始化节点数据
var player_control:bool
var player_career:String
var player_gender:String
var player_angle:int
var player_action:String
var player_action_speed:int
var player_step_length:int
var player_target_position:Vector2

# 如果鼠标事件未被其他场景、节点等资源消耗则触发该函数
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if (event.button_index == 1 and event.pressed) or (event.button_index == 2 and event.pressed):
			player_control = true
		else:
			player_control = false

func _ready():
	# 默认禁用控制
	player_control = false
	# 默认隐藏玩家主体
	player_father.visible = false
	# 初始化玩家数据
	player_nickname.text = Player.get_nickname_value()
	player_career = Player.get_career_value()
	player_gender = Player.get_gender_value()
	player_angle = Player.get_angle_value()
	player_header_life_value.text = Player.get_life_career_format()
	player_header_life.value = Player.get_life_percentage()
	player_header_magic.value = Player.get_magic_percentage()
	player_action = "stand"
	player_action_speed = 0
	player_step_length = 10
	# 加载玩家数据资源
	loader_player_resources()
	# 玩家默认状态
	on_action_stop()

func loader_player_resources():
	# 加载玩家服饰
	loader_player_clothe()
	# 加载玩家武器
	loader_player_weapon()
	# 加载玩家装饰
	loader_player_wing()
	# 显示玩家主体
	player_father.visible = true

func loader_player_clothe():
	# 服饰资源路径
	var clothe_path = Player.get_clothe()
	# 加载服饰资源
	var clothe_loader = load(clothe_path).instantiate()
	clothe_loader.name = "Clothe"
	# 将服饰资源添加到玩家Body节点
	player_body.add_child(clothe_loader)
	# 设置服饰资源层级
	player_body.move_child(clothe_loader, 0)
	# 设置服饰资源动画速度缩放比
	clothe_loader.speed_scale = 8
	# 默认播放
	clothe_loader.play()

func loader_player_weapon():
	# 当前玩家武器的编号
	var weapon_id = Player.get_weapon_value()
	if weapon_id != "000":
		# 武器资源路径
		var weapon_path = Player.get_weapon()
		# 加载武器资源
		var weapon_loader = load(weapon_path).instantiate()
		weapon_loader.name = "Weapon"
		# 将武器资源添加到玩家Body节点
		player_body.add_child(weapon_loader)
		# 设置武器资源层级
		player_body.move_child(weapon_loader, 1)
		# 设置武器资源动画速度缩放比
		weapon_loader.speed_scale = 8
		# 默认播放
		weapon_loader.play()

func loader_player_wing():
	# 当前玩家翅膀的编号
	var wing_id = Player.get_wing_value()
	if wing_id != "000":
		# 翅膀资源路径
		var wing_path = Player.get_wing()
		# 加载翅膀资源
		var wing_loader = load(wing_path).instantiate()
		wing_loader.name = "Wing"
		# 将翅膀资添加到玩家Body节点
		player_body.add_child(wing_loader)
		# 设置翅膀资源层级
		player_body.move_child(wing_loader, 2)
		# 设置翅膀资源动画速度缩放比
		wing_loader.speed_scale = 8
		# 默认播放
		wing_loader.play()

func _physics_process(_delta):
	if player_control and player_father.visible:
		# 获取窗口的边界
		var viewport_rect = get_viewport_rect()
		# 获取鼠标的位置
		var viewport_mouse_position = get_viewport().get_mouse_position()
		# 检查鼠标是否在窗口内
		if viewport_rect.has_point(viewport_mouse_position):
			# 获取玩家的位置
			var player_position = position
			# 获取鼠标的位置
			var mouse_position = get_local_mouse_position()
			# 获取鼠标的角度(以弧度为单位)并捕捉最接近45度的倍数(0,1,2,3,4,-4,-3,-2,-1)，将获取的倍数分别除以45度(0,1,2,3,4,5,6,7)
			player_angle = wrapi(int(snapped(mouse_position.angle(), PI/4) / (PI/4)), 0, 8)
			# 根据角度更新玩家装备渲染层级
			on_switch_layer()
			# 计算方向向量
			var direction = Vector2(cos(player_angle * PI/4), sin(player_angle * PI/4))
			if Input.is_action_pressed("walking") or Input.is_action_pressed("running"):
				if Input.is_action_pressed("walking"):
					player_action = "walking"
					player_action_speed = 70
					player_step_length = 50
				if Input.is_action_pressed("running"):
					player_action = "running"
					player_action_speed = 160
					player_step_length = 100
				# 满足条件才能运动
				if player_action_speed > 0 and mouse_position.length() > 15:
					player_body.get_child(0).animation = str(player_angle) + "_" + player_action
					player_body.get_child(0).play()
					var weapon_id = Player.get_weapon_value()
					if weapon_id != "000":
						player_body.get_child(1).animation = str(player_angle) + "_" + player_action
						player_body.get_child(1).play()
					var wing_id = Player.get_wing_value()
					if wing_id != "000":
						player_body.get_child(2).animation = str(player_angle) + "_" + player_action
						player_body.get_child(2).play()
					# 目标位置
					player_target_position = player_position + direction * player_step_length
					# 目标速度
					velocity = direction.normalized() * player_action_speed
					# 未到达目标位置则运动
					if position.distance_to(player_target_position) > 0:
						move_and_slide()
					else:
						on_action_stop()
			if Input.is_action_just_released("walking") or Input.is_action_just_released("running"):
				on_action_stop()
		else:
			on_action_stop()
	else:
		on_action_stop()
	
	#if Action.get_status() and player_father:
		## 更新并获取玩家位置
		#var player_position = Action.update_player_position(position)
		## 更新并获取鼠标位置
		#var mouse_position = Action.update_mouse_position(get_local_mouse_position())
		## 更新并获取角度
		#var angle = Action.update_mouse_angle(mouse_position)
		## 获取方向量
		#var direction = Action.get_direction()
		## 根据角度更新玩家装备渲染层级
		#on_switch_layer(angle)
		## 动作控制
		#var action = Action.get_action()
		#if action != "stand":
			#Action.set_move(true)
			#player_body.get_child(0).animation = str(angle) + "_" + action
			#player_body.get_child(0).play()
			#var weapon_id = Player.get_weapon_value()
			#if weapon_id != "000":
				#player_body.get_child(1).animation = str(angle) + "_" + action
				#player_body.get_child(1).play()
			#var wing_id = Player.get_wing_value()
			#if wing_id != "000":
				#player_body.get_child(2).animation = str(angle) + "_" + action
				#player_body.get_child(2).play()
			## 获取速度
			#var speed = Action.get_speed()
			## 获取步长
			#var step_length = Action.get_step_length()
			#if speed > 0 and mouse_position.length() > 15:
				## 更新并获取目标位置
				#var target_position = Action.update_player_target_position(player_position + direction * step_length)
				#velocity = direction.normalized() * speed
				#if position.distance_to(target_position) > 0:
					#move_and_slide()
		#else:
			#on_action_stop()
	#else:
		#on_action_stop()

func on_switch_layer():
	var weapon_id = Player.get_weapon_value()
	if weapon_id != "000":
		if player_angle == 3 or player_angle == 4 or player_angle == 5:
			if player_body.get_child(0).name == "Clothe":
				player_body.move_child(player_body.get_child(1), 0)
		else:
			if player_body.get_child(0).name == "Weapon":
				player_body.move_child(player_body.get_child(1), 0)

func on_action_stop():
	velocity = Vector2.ZERO
	player_action_speed = 0
	velocity = Vector2.ZERO
	player_action = "stand"
	player_body.get_child(0).animation = str(player_angle) + "_" + player_action
	var weapon_id = Player.get_weapon_value()
	if weapon_id != "000":
		player_body.get_child(1).animation = str(player_angle) + "_" + player_action
	var wing_id = Player.get_wing_value()
	if wing_id != "000":
		player_body.get_child(2).animation = str(player_angle) + "_" + player_action
