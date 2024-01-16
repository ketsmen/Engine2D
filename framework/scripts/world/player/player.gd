#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

# 实例化控件
@onready var player_father:Sprite2D = $Father
@onready var player_body:Control = $Father/Body
@onready var player_header:Control = $Father/Header
@onready var player_header_life_value:Label = $Father/Header/LifeValue
@onready var player_header_life:TextureProgressBar = $Father/Header/Life
@onready var player_header_magic:TextureProgressBar = $Father/Header/Magic
@onready var player_nickname:Label = $Father/NickName

# 初始化节点数据
var player_career: String
var player_gender: String
var player_angle: int
var player_action: String
var player_action_speed: int
var player_step_length: int

func _ready():
	# 默认禁用控制
	Global.data["is_control"] = false
	# 默认隐藏玩家主体
	player_father.visible = false
	# 初始化玩家数据
	player_nickname.text = Global.data["world"]["player"]["nickname"]
	player_career = Global.data["world"]["player"]["career"]
	player_gender = Global.data["world"]["player"]["gender"]
	player_angle = Global.data["world"]["player"]["angle"]
	player_header_life_value.text = str(Global.data["world"]["player"]["asset"]["life"]) + "/" + str(Global.data["world"]["player"]["asset"]["life_max"])
	player_header_life.value = (float(Global.data["world"]["player"]["asset"]["life"]) / float(Global.data["world"]["player"]["asset"]["life_max"])) * 100
	player_header_magic.value = (float(Global.data["world"]["player"]["asset"]["magic"]) / float(Global.data["world"]["player"]["asset"]["magic_max"])) * 100
	player_action = "stand"
	player_action_speed = 0
	player_step_length = 10
	# 加载玩家数据于资源
	loader_player_resources()
	# 玩家默认状态
	on_action_stop()

func loader_player_resources():
	print(player_father.get_child_count())
	# 加载玩家服饰
	loader_player_clothe()
	# 加载玩家武器
	# 加载玩家装饰
	# 更新至允许控制状态
	Global.data["is_control"] = true
	# 显示玩家主体
	player_father.visible = true

func loader_player_clothe():
	# 当前玩家服饰的编号
	var clothe_id = Global.data["world"]["player"]["body"]["clothe"]
	# 服饰资源路径
	var clothe_path = Global.data["config"]["clothe_path"] + clothe_id + "/" + player_gender + ".tscn"
	# 加载服饰资源
	var clothe_loader = load(clothe_path).instantiate()
	clothe_loader.name = "Clothe"
	# 将服饰资源添加到玩家Body节点
	player_body.add_child(clothe_loader)
	# 设置地图资源层级
	player_body.move_child(clothe_loader, 0)

func _physics_process(_delta):
	if Global.data["is_control"] and player_father:
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
			# 获取鼠标的角度(以弧度为单位)并捕捉最接近45度的倍数(0,1,2,3,4,-4,-3,-2,-1)
			var angle = snapped(mouse_position.angle(), PI/4) / (PI/4)
			# 将获取的倍数分别除以45度(0,1,2,3,4,5,6,7)
			player_angle = wrapi(int(angle), 0, 8)
			# 计算方向向量
			var direction = Vector2(cos(player_angle * PI/4), sin(player_angle * PI/4))
			# 修正角方向偏移
			if player_angle == 1:
				direction = Vector2(0.7, 0.4)
			if player_angle == 3:
				direction = Vector2(-0.7, 0.4)
			if player_angle == 5:
				direction = Vector2(-0.7, -0.4)
			if player_angle == 7:
				direction = Vector2(0.7, -0.4)
			# 鼠标左右键按下时触发
			if Input.is_action_pressed("walking") or Input.is_action_pressed("running"):
				# 更新速度
				if Input.is_action_pressed("walking"):
					player_action = "walking"
					# 鼠标左键行走
					player_action_speed = 60
				if Input.is_action_pressed("running"):
					player_action = "running"
					# 鼠标左键奔跑
					player_action_speed = 120
				if player_action_speed > 0:
					# 鼠标位置距离玩家多远才触发
					if mouse_position.length() > 10:
						player_body.get_child(0).animation = str(player_angle) + "_" + player_action
						velocity = direction.normalized() * player_action_speed
						move_and_slide()
			if Input.is_action_just_released("walking") or Input.is_action_just_released("running"):
				on_action_stop()
	else:
		on_action_stop()

func on_action_stop():
	player_action_speed = 0
	velocity = Vector2.ZERO
	player_action = "stand"
	player_body.get_child(0).animation = str(player_angle) + "_" + player_action
