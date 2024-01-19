#*****************************************************************************
# @file    login.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var sound:AudioStreamPlayer = $Sound
@onready var dialog:Control = $Dialog
@onready var main:TextureRect = $Main
@onready var email_input:LineEdit = $Main/EmailInput
@onready var password_input:LineEdit = $Main/PasswordInput
@onready var submit_button:TextureButton = $Main/SubmitButton
@onready var register_button:TextureButton = $Main/RegisterButton
@onready var change_password_button:TextureButton = $Main/ChangePasswordButton
@onready var register:Control = $Register
@onready var register_box:TextureRect = $Register/Box
@onready var register_account:LineEdit = $Register/Box/AccountInput
@onready var register_password:LineEdit = $Register/Box/PasswordInput
@onready var register_confirm_password:LineEdit = $Register/Box/ConfirmPasswordInput
@onready var register_name:LineEdit = $Register/Box/NameInput
@onready var register_number:LineEdit = $Register/Box/NumberInput
@onready var register_question_a:LineEdit = $Register/Box/QuestionAInput
@onready var register_answer_a:LineEdit = $Register/Box/AnswerAInput
@onready var register_question_b:LineEdit = $Register/Box/QuestionBInput
@onready var register_answer_b:LineEdit = $Register/Box/AnswerBInput
@onready var register_confirm_button:TextureButton = $Register/Box/ConfirmButton
@onready var register_cancel_button:TextureButton = $Register/Box/CancelButton
@onready var change_password:Control = $ChangePassword
@onready var change_account:LineEdit = $ChangePassword/Box/AccountInput
@onready var change_old_password:LineEdit = $ChangePassword/Box/PasswordInput
@onready var change_new_password:LineEdit = $ChangePassword/Box/NewPasswordInput
@onready var change_confirm_new_password:LineEdit = $ChangePassword/Box/ConfirmNewPasswordInput
@onready var change_password_confirm_button:TextureButton = $ChangePassword/Box/ConfirmButton
@onready var change_password_cancel_button:TextureButton = $ChangePassword/Box/CancelButton

# 自定义信号
signal submit_button_pressed(status: bool)

func _ready():
	# 显示当前节点场景
	visible = true
	# 隐藏密码修改窗口
	change_password.visible = false
	# 隐藏注册窗口
	register.visible = false
	# 登录游戏按钮允许点击
	submit_button.disabled = false
	# 实例化弹出层
	dialog = find_child("Dialog")

func _on_submit_button_pressed():
	# 校验用户登录数据
	if email_input.text != "" and password_input.text != "":
		# 验证邮箱格式
		var regex = RegEx.new()
		regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$")
		if !regex.search(email_input.text):
			dialog.show_message("邮箱格式不正确", 0)
			return
		var login_data = {
			"account": email_input.text,
			"password": password_input.text
		}
		submit_button.disabled = true
		Request.on_service("/game/user/login", HTTPClient.METHOD_POST, login_data, func (_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response["code"] == 0:
					dialog.show_message("账号登录成功", 0)
					User.data["token"] = response["data"]["token"]
					User.data["area"]["list"] = response["data"]["areas"]
					submit_button.disabled = false
					email_input.text = ""
					password_input.text = ""
					submit_button_pressed.emit(true)
				else:
					submit_button.disabled = false
					dialog.show_message(response["msg"], 0)
			else:
				submit_button.disabled = false
				dialog.show_message("登录失败，请重新尝试", 0)
		)
	else:
		dialog.show_message("登录信息不完整", 0)

func _on_change_password_button_pressed():
	# 显示密码修改窗口
	change_account.text = ""
	change_old_password.text = ""
	change_new_password.text = ""
	change_confirm_new_password.text = ""
	change_password.visible = true

func _on_confirm_button_pressed(type: String):
	if type == "change_password":
		# 修改密码
		pass
	if type == "register":
		# 注册账号
		var register_status = true
		for i in range(register_box.get_child_count()):
			if register_box.get_child(i) == LineEdit and register_box.get_child(i).text == "":
				register_status = false
		if register_status:
			# 验证邮箱格式
			var regex = RegEx.new()
			regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$")
			if !regex.search(register_account.text):
				dialog.show_message("邮箱格式不正确", 0)
				return
			# 验证密码
			if register_password.text != register_confirm_password.text:
				dialog.show_message("登录密码不一致", 0)
				return
			register_confirm_button.disabled = true
			var register_data = {
				"account": register_account.text,
				"password": register_password.text,
				"name": register_name.text,
				"number": register_number.text,
				"question_a": register_question_a.text,
				"answer_a": register_answer_a.text,
				"question_b": register_question_b.text,
				"answer_b": register_answer_b.text,
			}
			Request.on_service("/game/user/register", HTTPClient.METHOD_POST, register_data, func (_result, code, _headers, body):
				if code == 200:
					var response = JSON.parse_string(body.get_string_from_utf8())
					if response["code"] == 0:
						dialog.show_message("账号注册成功", 0)
						register_confirm_button.disabled = false
						_on_cancel_button_pressed()
					else:
						register_confirm_button.disabled = false
						dialog.show_message(response["msg"], 0)
				else:
					register_confirm_button.disabled = false
					dialog.show_message("注册失败，请重新尝试", 0)
			)
		else:
			dialog.show_message("注册信息不完整", 0)
			
func _on_cancel_button_pressed():
	# 隐藏窗口
	change_password.visible = false
	register.visible = false

func _on_register_button_pressed():
	# 显示注册窗口
	register_account.text = ""
	register_password.text = ""
	register_confirm_password.text = ""
	register_name.text = ""
	register_number.text = ""
	register_question_a.text = ""
	register_answer_a.text = ""
	register_question_b.text = ""
	register_answer_b.text = ""
	register.visible = true

func _on_sound_finished():
	# 确保背景音效循环播放
	sound.play()
