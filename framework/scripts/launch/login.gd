#*****************************************************************************
# @file    login.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化控件
@onready var email_input:LineEdit = $Main/EmailInput
@onready var password_input:LineEdit = $Main/PasswordInput

# 自定义信号
signal submit_button_pressed(email: String, password: String, status: bool)

# 初始化节点数据
var login_email: String = ""
var login_password: String = ""

func _ready():
	# 设置节点默认数据
	login_email = ""
	login_password = ""
	email_input.text = ""
	password_input.text = ""
	# 显示当前节点场景
	visible = true
	# 隐藏密码修改窗口
	$ChangePassword.visible = false
	# 隐藏注册窗口
	$Register.visible = false
	# 登录游戏按钮允许点击
	$Main/SubmitButton.disabled = false
	# 背景音效

func _on_submit_button_pressed():
	# 获取用户登录数据
	login_email = email_input.text
	login_password = password_input.text
	# 校验用户登录数据
	if login_email != "" and login_password != "":
		# TODO 请求服务端接口
		submit_button_pressed.emit(login_email, login_password, true)
		# 清空节点数据
		login_email = ""
		login_password = ""
		email_input.text = ""
		password_input.text = ""
		return
	submit_button_pressed.emit(login_email, login_password, false)

func _on_change_password_button_pressed():
	# 显示密码修改窗口
	$ChangePassword.visible = true

func _on_confirm_button_pressed(type: String):
	if type == "change_password":
		# 修改密码
		pass
	if type == "register":
		# 注册账号
		pass

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
