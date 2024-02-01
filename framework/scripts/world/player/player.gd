#*****************************************************************************
# @file    player.gd
# @author  MakerYang
#*****************************************************************************
extends CharacterBody2D

## 玩家类
class_name Player

# 实例化控件
@onready var player_father:Control = $Father
@onready var player_body:Control = $Father/Body
@onready var player_header:Control = $Father/Header
@onready var player_header_life_value:Label = $Father/Header/LifeValue
@onready var player_header_life:TextureProgressBar = $Father/Header/Life
@onready var player_header_magic:TextureProgressBar = $Father/Header/Magic
@onready var player_nickname:Label = $Father/NickName

# 初始化节点数据
@export var player_control_status:bool
@export var player_token:String
@export var player_angle:int
@export var player_clothe:AnimatedSprite2D
@export var player_weapon:AnimatedSprite2D
@export var player_wing:AnimatedSprite2D
@export var player_action:String
@export var player_move_status:bool
@export var player_move_speed:int
@export var player_move_step:int
@export var player_target_position:Vector2

# 如果鼠标事件未被其他场景、节点等资源消耗则触发该函数
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if (event.button_index == 1 and event.pressed) or (event.button_index == 2 and event.pressed):
			player_control_status = true
		else:
			player_control_status = false

func _ready():
	# 更新玩家Token
	player_token = get_meta("token")
	# 默认禁用控制
	player_control_status = false
	# 默认隐藏玩家主体
	player_father.visible = false
	# 初始化玩家方向
	player_angle = Global.get_player_angle(player_token)
	# 初始化玩家动作
	player_action = "stand"
	# 初始化玩家位置
	position = Utils.convert_map_to_world(Global.get_player_coordinate(player_token))
	player_target_position = position
	# 更新玩家数据
	update_player_data()
	# 加载玩家数据资源
	loader_player_resources()

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
	player_clothe = Global.loader_player_clothe_resource(player_token)
	player_body.add_child(player_clothe)
	player_body.move_child(player_clothe, 0)
	player_clothe.play()
	# 加载玩家武器
	player_weapon = Global.loader_player_weapon_resource(player_token)
	if player_weapon:
		player_body.add_child(player_weapon)
		player_body.move_child(player_weapon, 1)
		player_weapon.play()
	# 加载玩家装饰
	player_wing = Global.loader_player_wing_resource(player_token)
	if player_wing:
		player_body.add_child(player_wing)
		player_body.move_child(player_wing, 2)
		player_wing.play()
	# 显示玩家主体
	player_father.visible = true

func _physics_process(_delta):
	if player_father.visible:
		# 更新玩家数据
		update_player_data()
		# 获取窗口的边界
		var viewport_rect = get_viewport_rect()
		# 获取鼠标的位置
		var viewport_mouse_position = get_viewport().get_mouse_position()
		# 如果鼠标是否在窗口内且允许控制
		if viewport_rect.has_point(viewport_mouse_position) and player_control_status:
			# 按键检测
			if player_action == "stand":
				if Input.is_action_pressed("walking") and !Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
					player_action = "walking"
				if Input.is_action_pressed("running") and !Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
					player_action = "running"
				if Input.is_action_pressed("walking") and Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
					player_action = "attack"
				if Input.is_action_pressed("walking") and !Input.is_action_pressed("shift") and Input.is_action_pressed("ctrl"):
					player_action = "pickup"
				# 获取鼠标位置
				var mouse_position = get_local_mouse_position()
				# 更新玩家方向
				if player_action in ["walking", "running", "attack", "pickup", "launch"] and !player_move_status:
					player_angle = Global.update_player_angle(player_token, wrapi(int(snapped(mouse_position.angle(), PI/4) / (PI/4)), 0, 8))
				# 切换玩家资源层级
				on_switch_weapon_index()
				if mouse_position.length() > 40:
					if player_action == "walking":
						player_move_speed = 80
						player_move_step = 1
					if player_action == "running":
						player_move_speed = 160
						player_move_step = 2
				else:
					player_action = "stand"
					player_move_speed = 0
					player_move_step = 0
# 切换玩家动作状态
func on_switch_action_status() -> void:
	if player_clothe:
		player_clothe.animation = str(player_angle) + "_" + player_action
	if player_weapon:
		player_weapon.animation = str(player_angle) + "_" + player_action
	if player_wing:
		player_wing.animation = str(player_angle) + "_" + player_action

# 切换玩家资源层级
func on_switch_weapon_index() -> void:
	if player_weapon:
		if player_angle in [3, 4, 5]:
			player_body.move_child(player_body.get_node("Weapon"), 0)
			player_body.move_child(player_body.get_node("Clothe"), 1)
		else:
			player_body.move_child(player_body.get_node("Weapon"), 1)
			player_body.move_child(player_body.get_node("Clothe"), 0)
	if player_wing:
		pass

# 更新目标位置
func update_target_position() -> void:
	var target_position = Vector2.ZERO
	var step = player_move_step
	var size = Global.get_map_grid_size()
	if player_angle == 0:
		target_position = Vector2(position.x + (step * size.x), position.y)
	if player_angle == 1:
		target_position = Vector2(position.x + (step * size.x), position.y + (step * size.y))
	if player_angle == 2:
		target_position = Vector2(position.x, position.y + (step * size.y))
	if player_angle == 3:
		target_position = Vector2(position.x - (step * size.x), position.y + (step * size.y))
	if player_angle == 4:
		target_position = Vector2(position.x - (step * size.x), position.y)
	if player_angle == 5:
		target_position = Vector2(position.x - (step * size.x), position.y - (step * size.y))
	if player_angle == 6:
		target_position = Vector2(position.x, position.y - (step * size.y))
	if player_angle == 7:
		target_position = Vector2(position.x + (step * size.x), position.y - (step * size.y))
	player_target_position = target_position
