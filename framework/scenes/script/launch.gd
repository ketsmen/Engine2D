extends Control

# 初始化用户登录数据
var login_mail: String = ""
var login_password: String = ""

func _ready():
	# 默认清空用户登录数据
	login_mail = ""
	login_password = ""

func _process(_delta):
	pass

func _on_launch_sound_finished():
	print("Launch Sound End")
	# 确保背景音效循环播放
	$LaunchSound.play()

func _on_start_button_pressed():
	print("Launch Login Start")
	# 获取用户登录数据
	login_mail = $Login/Main/LoginMail.text
	login_password = $Login/Main/LoginPassword.text
	# 校验用户登录数据
	if login_mail != "" and login_password != "":
		$Login/Main.visible = false
		$Login/Progress.visible = true
