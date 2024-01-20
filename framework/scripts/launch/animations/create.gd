#*****************************************************************************
# @file    character.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 初始化节点数据
var character_gender: Array = ["Men", "Women"]
var character_career: Array = ["Warrior", "Mage", "Taoist"]
var current_gender: int = 0
var current_career: int = 0

func _ready():
	# 设置所有子节点默认不显示
	$Warrior.visible = false
	$Mage.visible = false
	$Taoist.visible = false
	$Career.visible = false
	$Info/Gender.visible = false
	# 性别切换控件的初始配置
	$Info/Gender/Men.toggle_mode = true
	$Info/Gender/Men.keep_pressed_outside = true
	$Info/Gender/Women.toggle_mode = true
	$Info/Gender/Women.keep_pressed_outside = true
	pass
	
func _process(_delta):
	# 显示职业切换控件
	if !$Career.visible:
		$Career.visible = true
	# 显示性别切换控件
	if !$Info/Gender.visible:
		$Info/Gender.visible = true
	# 性别切换控件状态检测
	if current_gender == 0:
		$Info/Gender/Men.button_pressed = true
		$Info/Gender/Women.button_pressed = false
	else:
		$Info/Gender/Men.button_pressed = false
		$Info/Gender/Women.button_pressed = true
	# 根据性别和职业展示节点
	if current_career == 0:
		$Mage.visible = false
		$Taoist.visible = false
		if current_gender == 0:
			$Warrior/Women.animation = "default"
			$Warrior/Women.stop()
			$Warrior/Men.animation = "play"
			$Warrior/Men.play()
		else:
			$Warrior/Men.animation = "default"
			$Warrior/Men.stop()
			$Warrior/Women.animation = "play"
			$Warrior/Women.play()
		$Warrior.visible = true
	if current_career == 1:
		$Warrior.visible = false
		$Taoist.visible = false
		if current_gender == 0:
			$Mage/Women.animation = "default"
			$Mage/Women.stop()
			$Mage/Men.animation = "play"
			$Mage/Men.play()
		else:
			$Mage/Men.animation = "default"
			$Mage/Men.stop()
			$Mage/Women.animation = "play"
			$Mage/Women.play()
		$Mage.visible = true
	if current_career == 2:
		$Warrior.visible = false
		$Mage.visible = false
		if current_gender == 0:
			$Taoist/Women.animation = "default"
			$Taoist/Women.stop()
			$Taoist/Men.animation = "play"
			$Taoist/Men.play()
		else:
			$Taoist/Men.animation = "default"
			$Taoist/Men.stop()
			$Taoist/Women.animation = "play"
			$Taoist/Women.play()
		$Taoist.visible = true

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
