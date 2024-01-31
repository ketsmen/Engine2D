#*****************************************************************************
# @file    launch.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var background:Control = $Background
@onready var login:Control = $Login
@onready var server:Control = $Server
@onready var role:Control = $Role
@onready var loading:Control = $Loading
@onready var dialog:Control = $Dialog
@onready var dialog_message:Control = $Dialog/Message
@onready var dialog_message_content:Control = $Dialog/Message/Background/Content

func _ready():
	# 初始化子节点状态
	dialog_message.modulate.a = 0
	server.visible = false
	role.visible = false
	loading.visible = false
	login.visible = true
	login.sound.play()
	# 如果加载来源是游戏主界面
	if Utils.data["source"] == "world":
		_on_server_item_pressed(Global.get_account_area_token())
		Utils.data["source"] = ""

func _on_login_submit_button_pressed(status: bool):
	if status:
		server.update_server()
		login.visible = false
		server.visible = true

func _on_server_item_pressed(area_token: String):
	# 更新服务区Token
	Global.set_account_area_token(area_token)
	Global.set_account_area_list([])
	# 获取用户所在服务区的玩家角色
	Request.on_service("/game/user/role/list?token=" + area_token, HTTPClient.METHOD_GET, {}, func (_result, code, _headers, body):
		if code == 200:
			var response = JSON.parse_string(body.get_string_from_utf8())
			if response["code"] == 0:
				Global.set_account_area_role_list(response["data"]["roles"])
				# 创建补间动画
				var tween = get_tree().create_tween()
				tween.set_parallel(true)
				# 隐藏服务区界面
				server.visible = false
				tween.tween_property(background, "modulate:a", 0, 0.5)
				# 显示角色管理界面
				role.visible = true
				tween.tween_property(role, "modulate:a", 1, 1)
				# 停止登录界面音乐
				login.sound.stop()
				# 播放角色界面音乐
				role.sound.play()
			else:
				on_message(response["msg"], 0)
		else:
			on_message("服务器请求失败，请重新尝试", 0)
	)

func _on_roles_return_button_pressed():
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(role, "modulate:a", 0, 0.5)
	server.visible = false
	role.visible = false
	role.sound.stop()
	login.sound.play()
	tween.tween_property(background, "modulate:a", 1, 1)
	login.visible = true

func _on_roles_start_button_pressed():
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(role, "modulate:a", 0, 0.5)
	server.visible = false
	role.visible = false
	role.sound.stop()
	login.sound.stop()
	tween.tween_property(background, "modulate:a", 1, 1)
	loading.visible = true
	loading.on_loader()

func on_message(content: String, duration: int):
	dialog_message_content.text = content
	dialog_message.modulate.a = 1
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	if duration == 0:
		duration = 2
	tween.tween_property(dialog_message, "modulate:a", 0, 0.5).set_delay(duration)
