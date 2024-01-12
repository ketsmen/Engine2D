#*****************************************************************************
# @file    launch.gd
# @author  MakerYang
#*****************************************************************************
extends Control

func _ready():
	# 初始化子节点状态
	$Server.visible = false
	$Roles.visible = false
	$Login.visible = true
	$Login/Sound.play()

func _process(_delta):
	pass

#func _on_item_pressed():
	## 创建补间动画
	#var tween = get_tree().create_tween()
	## 设置多个动画同步处理
	#tween.set_parallel(true)
	## 背景淡出并隐藏$Server
	#tween.tween_property($Background, "modulate:a", 0.5, 1)
	#$Server.visible = false
	#$Player/Background.modulate = Color(1, 1, 1, 0)
	#$Player/Main.modulate = Color(1, 1, 1, 0)
	#$Player/Footer.modulate = Color(1, 1, 1, 0)
	#$Player/Main/Box/Animation.animation = "warrior_men"
	#$Player/Main/Box/Animation.play()
	#$Player.visible = true
	#tween.tween_property($Player/Background, "modulate:a", 1, 1).set_trans(Tween.TRANS_QUAD)
	#tween.tween_property($Player/Main, "modulate:a", 1, 1.5).set_trans(Tween.TRANS_QUAD)
	#tween.tween_property($Player/Footer, "modulate:a", 1, 1.5).set_trans(Tween.TRANS_QUAD)


#func _on_new_button_pressed():
	#$Player/Main/Box/Animation.animation = "mage_men"
	#$Player/Main/Box/Animation.play()
#
#
#func _on_restore_button_pressed():
	#$Player/Main/Box/Animation.animation = "taoist_men"
	#$Player/Main/Box/Animation.play()
#
#
#func _on_delete_button_pressed():
	#$Player/Main/Box/Animation.animation = "mage_women"
	#$Player/Main/Box/Animation.play()
#
#func _on_exit_button_pressed():
	#$Player/Main/Box/Animation.animation = "taoist_women"
	#$Player/Main/Box/Animation.play()

func _on_login_submit_button_pressed(mail: String, password: String, status: bool):
	print(mail, password, status)
	if status:
		$Login.visible = false
		$Server.visible = true

func _on_server_item_pressed(server_token: String):
	print(server_token)
	# 创建补间动画
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	# 隐藏$Server并且背景淡出
	$Server.visible = false
	tween.tween_property($Background, "modulate:a", 0, 0.5)
	$Roles.visible = true
	tween.tween_property($Roles/Background, "modulate:a", 1, 1)
	$Login/Sound.stop()
	$Roles/Sound.play()
