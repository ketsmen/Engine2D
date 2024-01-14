#*****************************************************************************
# @file    launch.gd
# @author  MakerYang
#*****************************************************************************
extends Control

func _ready():
	# 初始化子节点状态
	$Server.visible = false
	$Roles.visible = false
	$Loading.visible = false
	$Login.visible = true
	$Login/Sound.play()

func _process(_delta):
	pass

func _on_login_submit_button_pressed(mail: String, password: String, status: bool):
	print(mail, password, status)
	var dialog = get_node("Dialog")
	if status:
		$Login.visible = false
		$Server.visible = true
	else:
		dialog.show_message("登录信息不完整", 0)

func _on_server_item_pressed(server_token: String):
	print(server_token)
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	# 隐藏$Server并且背景淡出
	$Server.visible = false
	tween.tween_property($Background, "modulate:a", 0, 0.5)
	$Roles.visible = true
	tween.tween_property($Roles, "modulate:a", 1, 1)
	$Login/Sound.stop()
	$Roles/Sound.play()

func _on_roles_return_button_pressed():
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Roles, "modulate:a", 0, 0.5)
	$Server.visible = false
	$Roles.visible = false
	$Roles/Sound.stop()
	$Login/Sound.play()
	tween.tween_property($Background, "modulate:a", 1, 1)
	$Login.visible = true

func _on_roles_start_button_pressed():
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Roles, "modulate:a", 0, 0.5)
	$Server.visible = false
	$Roles.visible = false
	$Roles/Sound.stop()
	$Login/Sound.stop()
	tween.tween_property($Background, "modulate:a", 1, 1)
	$Loading.visible = true
	$Loading.on_loader()
