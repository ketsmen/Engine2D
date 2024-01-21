#*****************************************************************************
# @file    character.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var warrior:Control = $Warrior
@onready var warrior_men:AnimatedSprite2D = $Warrior/Men
@onready var warrior_women:AnimatedSprite2D = $Warrior/Women
@onready var mage:Control = $Mage
@onready var mage_men:AnimatedSprite2D = $Mage/Men
@onready var mage_women:AnimatedSprite2D = $Mage/Women
@onready var taoist:Control = $Taoist
@onready var taoist_men:AnimatedSprite2D = $Taoist/Men
@onready var taoist_women:AnimatedSprite2D = $Taoist/Women
@onready var career:Control = $Career
@onready var career_left_button:TextureButton = $Career/LeftButton
@onready var career_right_button:TextureButton = $Career/RightButton
@onready var info:Control = $Info
@onready var info_nickname:Control = $Info/Nickname/Background/Input
@onready var info_men:Control = $Info/Gender/Men
@onready var info_women:Control = $Info/Gender/Women
@onready var info_submit_button:TextureButton = $Info/SubmitButton
@onready var info_cancel_button:TextureButton = $Info/CancelButton

# 自定义信号
signal cancel_button_pressed

# 初始化节点数据
var current_gender_array:Array = ["men", "women"]
var current_career_array:Array = ["warrior", "mage", "taoist"]
var current_gender:int = 0
var current_career:int = 0
	
func _process(_delta):
	# 性别切换检测
	if current_gender == 0:
		info_men.button_pressed = true
		info_women.button_pressed = false
	else:
		info_men.button_pressed = false
		info_women.button_pressed = true
	# 职业切换检测
	if current_career == 0:
		career_left_button.disabled = true
	else:
		career_left_button.disabled = false
	if current_career == 2:
		career_right_button.disabled = true
	else:
		career_right_button.disabled = false
	# 职业检测
	for i in range(3):
		if current_career == i:
			if current_gender == 0:
				get_child(i).get_child(1).visible = false
				get_child(i).get_child(0).visible = true
			else:
				get_child(i).get_child(0).visible = false
				get_child(i).get_child(1).visible = true
			get_child(i).visible = true
		else:
			get_child(i).visible = false

func _on_left_button_pressed():
	if current_career > 0:
		current_career -= 1

func _on_right_button_pressed():
	if current_career < 2:
		current_career += 1

func _on_men_pressed():
	current_gender = 0

func _on_women_pressed():
	current_gender = 1

func _on_submit_button_pressed():
	if info_nickname.text != "":
		var submit_data = {
			"token": User.get_area_token_value(),
			"nickname": info_nickname.text,
			"gender": current_gender_array[current_gender],
			"career": current_career_array[current_career]
		}
		info_submit_button.disabled = true
		Request.on_service("/game/user/role/create", HTTPClient.METHOD_POST, submit_data, func (_result, code, _headers, body):
			if code == 200:
				var response = JSON.parse_string(body.get_string_from_utf8())
				if response["code"] == 0:
					Dialog.on_message("角色成功", 0)
					var current_role:Array = User.get_role_list()
					current_role.push_front(response["data"]["role"])
					User.set_role_list(current_role)
					info_submit_button.disabled = false
					_on_cancel_button_pressed()
				else:
					info_submit_button.disabled = false
					Dialog.on_message(response["msg"], 0)
			else:
				info_submit_button.disabled = false
				Dialog.on_message("角色创建失败，请重新尝试", 0)
		)
	else:
		Dialog.on_message("角色信息不完整", 0)

func _on_cancel_button_pressed():
	info_nickname.text = ""
	current_gender = 0
	current_career = 0
	cancel_button_pressed.emit()
