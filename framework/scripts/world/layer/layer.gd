#*****************************************************************************
# @file    layer.gd
# @author  MakerYang
#*****************************************************************************
extends CanvasLayer

# 实例化控件
@onready var min_box:Control = $MinMap
@onready var min_camera:Camera2D = $MinMap/Main/Min/Camera
@onready var min_location:TextureRect = $MinMap/Main/Min/Location
@onready var min_coordinate:Label = $MinMap/Coordinate
@onready var max_box:Control = $MaxMap
@onready var max_camera:Camera2D = $MaxMap/Main/Max/Camera
@onready var max_location:TextureRect = $MaxMap/Main/Max/Location
@onready var footer_box:Control = $Footer
@onready var footer_experience:BoxContainer = $Footer/Experience
@onready var footer_centre:Control = $Footer/Centre
@onready var footer_centre_round_left:TextureProgressBar = $Footer/Centre/Round/Left
@onready var footer_centre_round_right:TextureProgressBar = $Footer/Centre/Round/Right
@onready var footer_centre_round_light:AnimatedSprite2D = $Footer/Centre/Round/Light
@onready var footer_centre_level:Label = $Footer/Centre/Level
@onready var footer_centre_hp:Label = $Footer/Centre/Hp
@onready var footer_centre_mp:Label = $Footer/Centre/Mp
@onready var footer_left_box:Control = $Footer/Left
@onready var footer_left_time:Label = $Footer/Left/Time

func _ready():
	# 默认隐藏大地图
	max_box.visible = false

func _process(_delta):
	# 更新当前时间
	footer_left_time.text = Global.get_current_time()
	if owner.get_child(4):
		# 更新玩家当前位置
		Player.set_coordinate_value(owner.get_child(4).position)
		var current_coordinate = Player.get_coordinate_value()
		min_coordinate.text = "盟重省" + " " + str(int(current_coordinate.x)) + " " + str(int(current_coordinate.y))
		# 更新玩家等级
		footer_centre_level.text = str(Player.get_level_value())
		# 更新玩家生命值
		footer_centre_round_left.value = Player.get_life_percentage()
		footer_centre_hp.text = Player.get_life_format()
		# 更新玩家魔法值
		footer_centre_round_right.value = Player.get_magic_percentage()
		footer_centre_mp.text = Player.get_magic_format()
		# 更新生命球动画
		if footer_centre_round_left.value == 100 and footer_centre_round_right.value == 100:
			footer_centre_round_light.visible = true
		else:
			footer_centre_round_light.visible = false
		# 更新玩家经验数据
		update_footer_experience()
		# 相机位置同步
		min_camera.position = owner.get_child(4).position
		# 人物位置同步 TODO 待人物动画确定后需要计算人物偏移量
		min_location.position = owner.get_child(4).position
		if max_box.visible:
			# 如果大图显示，则生效
			max_location.position = owner.get_child(4).position
		# TODO 显示周边人物、NPC、怪物

func update_footer_experience():
	var status = Player.get_experience(footer_experience.get_child_count())
	for i in range(footer_experience.get_child_count()):
		var child = footer_experience.get_child(i) as TextureProgressBar
		var child_status = status[i]
		child.visible = child_status["visible"]
		child.value = child_status["value"]

func _on_max_show_button_pressed():
	if !max_box.visible:
		max_box.visible = true
		
func _on_max_hide_button_pressed():
	if max_box.visible:
		max_box.visible = false
