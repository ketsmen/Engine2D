extends Control

# 初始化用户登录数据
var login_mail: String = ""
var login_password: String = ""

func _ready():
	# 默认清空用户登录数据
	login_mail = ""
	login_password = ""
	# 初始化子节点状态
	$Server.visible = false
	$Player.visible = false
	$Progress.visible = false
	$Login.visible = true

func _process(_delta):
	pass

func _on_launch_sound_finished():
	# 确保背景音效循环播放
	$LaunchSound.play()

func _on_start_button_pressed():
	# 获取用户登录数据
	login_mail = $Login/Main/LoginMail.text
	login_password = $Login/Main/LoginPassword.text
	# 校验用户登录数据
	if login_mail != "" and login_password != "":
		# TODO 增加服务端校验
		$Login.visible = false
		$Server.visible = true

func _on_item_pressed():
	# 创建补间动画
	var tween = get_tree().create_tween()
	# 设置多个动画同步处理
	tween.set_parallel(true)
	# 背景淡出并隐藏$Server
	tween.tween_property($Background, "modulate:a", 0.5, 1)
	$Server.visible = false
	$Player/Background.modulate = Color(1, 1, 1, 0)
	$Player/Main.modulate = Color(1, 1, 1, 0)
	$Player/Footer.modulate = Color(1, 1, 1, 0)
	$Player/Main/Box/Animation.animation = "warrior_men"
	$Player/Main/Box/Animation.play()
	$Player.visible = true
	tween.tween_property($Player/Background, "modulate:a", 1, 1).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Player/Main, "modulate:a", 1, 1.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Player/Footer, "modulate:a", 1, 1.5).set_trans(Tween.TRANS_QUAD)


func _on_new_button_pressed():
	$Player/Main/Box/Animation.animation = "mage_men"
	$Player/Main/Box/Animation.play()


func _on_restore_button_pressed():
	$Player/Main/Box/Animation.animation = "taoist_men"
	$Player/Main/Box/Animation.play()


func _on_delete_button_pressed():
	$Player/Main/Box/Animation.animation = "mage_women"
	$Player/Main/Box/Animation.play()


func _on_exit_button_pressed():
	$Player/Main/Box/Animation.animation = "taoist_women"
	$Player/Main/Box/Animation.play()
