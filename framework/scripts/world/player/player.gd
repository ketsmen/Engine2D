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
		# 更新武器层级
		on_switch_weapon_index()
		# 运动控制
		if (player_action.find("walking") > 0 or player_action.find("running") > 0) and !Action.get_move_status():
			Action.update_move_status(true)
			player_target_position = Action.get_target_position(position)
		if position != player_target_position:
			velocity = position.direction_to(player_target_position) * Action.get_speed()
			if position.distance_squared_to(player_target_position) > 5:
				move_and_slide()
			else:
				Action.update_move_status(false)
				position = player_target_position
				Action.restore_default_actions()

func on_switch_weapon_index():
	if player_weapon:
		if Action.get_angle() in [3, 4, 5]:
			if player_body.get_child(0).name == "Clothe":
				player_body.move_child(player_body.get_child(1), 0)
		else:
			if player_body.get_child(0).name == "Weapon":
				player_body.move_child(player_body.get_child(1), 0)
