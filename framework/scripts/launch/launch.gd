#*****************************************************************************
# @file    launch.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var background:Control = $Background
@onready var login:Control = $Login
@onready var server:Control = $Server
@onready var roles:Control = $Roles
@onready var loading:Control = $Loading

func _ready():
	# 初始化子节点状态
	server.visible = false
	roles.visible = false
	loading.visible = false
	login.visible = true
	login.sound.play()

func _on_login_submit_button_pressed(status: bool):
	if status:
		server.update_server()
		login.visible = false
		server.visible = true

func _on_server_item_pressed(area_token: String):
	User.data["area"]["token"] = area_token
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	# 隐藏$Server并且背景淡出
	server.visible = false
	tween.tween_property(background, "modulate:a", 0, 0.5)
	roles.visible = true
	tween.tween_property(roles, "modulate:a", 1, 1)
	login.sound.stop()
	roles.sound.play()

func _on_roles_return_button_pressed():
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(roles, "modulate:a", 0, 0.5)
	server.visible = false
	roles.visible = false
	roles.sound.stop()
	login.sound.play()
	tween.tween_property(background, "modulate:a", 1, 1)
	login.visible = true

func _on_roles_start_button_pressed():
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(roles, "modulate:a", 0, 0.5)
	server.visible = false
	roles.visible = false
	roles.sound.stop()
	login.sound.stop()
	tween.tween_property(background, "modulate:a", 1, 1)
	loading.visible = true
	loading.on_loader()
