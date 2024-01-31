#*****************************************************************************
# @file    layer.gd
# @author  MakerYang
#*****************************************************************************
extends CanvasLayer

# 实例化控件
@onready var min_map_box:Control = $MinMap
@onready var min_map_main:Control = $MinMap/Main
@onready var min_map_camera:Camera2D = $MinMap/Main/Map/Min/Camera
@onready var min_map_location:TextureRect = $MinMap/Main/Map/Min/Location
@onready var min_map_coordinate:Label = $MinMap/Header/Coordinate
@onready var min_map_show_button:TextureButton = $MinMap/Header/Button/MinMapShow
@onready var min_map_hide_button:TextureButton = $MinMap/Header/Button/MinMapHide
@onready var max_map_box:Control = $MaxMap
@onready var max_map_camera:Camera2D = $MaxMap/Main/Map/Max/Camera
@onready var max_map_location:TextureRect = $MaxMap/Main/Map/Max/Location
@onready var chat_box:Control = $Chat
@onready var chat_left_button:Control = $Chat/Button/ChatLeftButton
@onready var chat_right_button:Control = $Chat/Button/ChatRightButton
@onready var footer_box:Control = $Footer
@onready var footer_experience:TextureProgressBar = $Footer/Experience
@onready var footer_centre:Control = $Footer/Centre
@onready var footer_centre_round_left:TextureProgressBar = $Footer/Centre/Round/Left
@onready var footer_centre_round_right:TextureProgressBar = $Footer/Centre/Round/Right
@onready var footer_centre_round_light:AnimatedSprite2D = $Footer/Centre/Round/Light
@onready var footer_centre_level:Label = $Footer/Centre/Level
@onready var footer_centre_hp:Label = $Footer/Centre/Hp
@onready var footer_centre_mp:Label = $Footer/Centre/Mp
@onready var footer_left_box:Control = $Footer/Left
@onready var footer_left_time:Label = $Footer/Left/Time
@onready var dialog_box:Control = $Dialog
@onready var dialog_confirm:Control = $Dialog/Confirm
@onready var dialog_confirm_content:Label = $Dialog/Confirm/ConfirmContent

# 初始化节点数据
var min_map_status:bool = true
var chat_box_status:bool = true
var dialog_callback:Callable = Callable()

func _ready():
	# 默认隐藏大地图
	max_map_box.visible = false
	# 默认隐藏Dialog资源
	dialog_box.visible = false
	dialog_confirm.visible = false

func _process(_delta):
	# 更新当前时间
	footer_left_time.text = Utils.get_current_time()
	# 更新小地图按钮状态
	if min_map_status:
		min_map_show_button.visible = false
		min_map_hide_button.visible = true
	else:
		min_map_hide_button.visible = false
		min_map_show_button.visible = true
	# 更新聊天框隐藏显示状态
	if chat_box_status:
		chat_right_button.visible = false
		chat_left_button.visible= true
	else:
		chat_left_button.visible = false
		chat_right_button.visible= true
	if Global.player:
		var player_token = Global.get_account_player_token()
		# 更新并返回坐标信息
		var current_coordinate = Global.update_player_coordinate(player_token, Global.map_node.get_child(0).local_to_map(Global.player.position))
		min_map_coordinate.text = Global.get_player_map_name(player_token) + " " + str(int(current_coordinate.x)) + " " + str(int(current_coordinate.y))
		# 更新玩家等级
		footer_centre_level.text = str(Global.get_player_level(player_token))
		# 更新玩家生命值
		footer_centre_round_left.value = Global.get_player_life_percentage(player_token)
		footer_centre_hp.text = Global.get_player_life_format(player_token)
		# 更新玩家魔法值
		footer_centre_round_right.value = Global.get_player_magic_percentage(player_token)
		footer_centre_mp.text = Global.get_player_magic_format(player_token)
		# 更新生命球动画
		if footer_centre_round_left.value == 100 and footer_centre_round_right.value == 100:
			footer_centre_round_light.visible = true
		else:
			footer_centre_round_light.visible = false
		# 更新玩家经验数据
		footer_experience.value = Global.get_player_experience(player_token)
		# 相机位置同步
		min_map_camera.position = Global.player.position
		# 人物位置同步 TODO 待人物动画确定后需要计算人物偏移量
		min_map_location.position = Global.player.position
		if max_map_box.visible:
			# 如果大图显示，则生效
			max_map_location.position = Vector2(Global.player.position.x - 12024, Global.player.position.y - 8016)
		# TODO 显示周边人物、NPC、怪物

func _on_min_map_show_pressed():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(min_map_main, "position:y", (min_map_main.position.y + 145), 0.2)
	min_map_status = true

func _on_min_map_hide_pressed():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(min_map_main, "position:y", (min_map_main.position.y - 145), 0.2)
	min_map_status = false

func _on_max_show_button_pressed():
	if !max_map_box.visible:
		max_map_box.visible = true
		
func _on_max_hide_button_pressed():
	if max_map_box.visible:
		max_map_box.visible = false

func _on_chat_left_button_pressed():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(chat_box, "position:x", (chat_box.position.x - 325), 0.2)
	chat_box_status = false

func _on_chat_right_button_pressed():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(chat_box, "position:x", (chat_box.position.x + 325), 0.2)
	chat_box_status = true

func _on_out_role_pressed():
	on_dialog_confirm("是否确认退出当前角色？", func ():
		get_parent().on_return_launch()
	)

func _on_out_game_pressed():
	on_dialog_confirm("是否确认退出游戏？", func ():
		get_tree().quit()
	)

func on_dialog_confirm(content: String, callback):
	dialog_confirm_content.text = content
	if callback:
		dialog_callback = callback
	dialog_confirm.visible = true
	dialog_box.visible = true

func _on_dialog_confirm_button_pressed():
	if dialog_callback:
		dialog_callback.call()

func _on_dialog_cancel_button_pressed():
	if not dialog_callback.is_null():
		dialog_callback = Callable()
	dialog_confirm_content.text = ""
	dialog_confirm.visible = false
	dialog_box.visible = false

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# 阻止默认退出事件
		get_tree().set_auto_accept_quit(false)
		# 弹窗确认
		_on_out_game_pressed()
