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

func _ready():
	# 初始化子节点状态
	server.visible = false
	role.visible = false
	loading.visible = false
	login.visible = true
	login.sound.play()

func _on_login_submit_button_pressed(status: bool):
	if status:
		server.update_server()
		login.visible = false
		server.visible = true

func _on_server_item_pressed(area_token: String):
	# 更新服务区Token
	User.set_area_token_value(area_token)
	User.set_area_list([])
	# 获取用户所在服务区的玩家角色
	Request.on_service("/game/user/role/list?token=" + area_token, HTTPClient.METHOD_GET, {}, func (_result, code, _headers, body):
		if code == 200:
			var response = JSON.parse_string(body.get_string_from_utf8())
			if response["code"] == 0:
				User.set_role_list(response["data"]["roles"])
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
				Dialog.on_message(response["msg"], 0)
		else:
			Dialog.on_message("服务器请求失败，请重新尝试", 0)
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
