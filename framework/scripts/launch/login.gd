#*****************************************************************************
# @file    login.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 自定义信号
signal submit_button_pressed(email: String, password: String, status: bool)

# 初始化用户登录数据
var login_email: String = ""
var login_password: String = ""

func _ready():
	# 默认清空用户登录数据
	login_email = ""
	login_password = ""
	# 显示当前节点场景
	visible = true
	# 隐藏密码修改窗口
	$ChangePassword.visible = false
	# 隐藏注册窗口
	$Register.visible = false

func _on_submit_button_pressed():
	# 获取用户登录数据
	login_email = $Main/EmailIpunt.text
	login_password = $Main/PasswordIpunt.text
	# 校验用户登录数据
	if login_email != "" and login_password != "":
		# TODO 请求服务端接口
		submit_button_pressed.emit(login_email, login_password, true)
		return
	submit_button_pressed.emit(login_email, login_password, false)

func _on_change_password_button_pressed():
	# 显示密码修改窗口
	$ChangePassword.visible = true

func _on_confirm_button_pressed(type: String):
	if type == "change_password":
		print("change_password")
		$ChangePassword.visible = false
	if type == "register":
		print("register")
		$Register.visible = false

func _on_cancel_button_pressed():
	# 隐藏密码修改窗口
	$ChangePassword.visible = false
	$Register.visible = false

func _on_register_button_pressed():
	# 显示注册窗口
	$Register.visible = true

func _on_sound_finished():
	# 确保背景音效循环播放
	$Sound.play()
