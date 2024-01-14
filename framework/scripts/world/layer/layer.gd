#*****************************************************************************
# @file    layer.gd
# @author  MakerYang
#*****************************************************************************
extends CanvasLayer

@onready var camera = $MiniMap/Main/Show/Camera
@onready var location = $MiniMap/Main/Show/Location

func _process(_delta):
	# 相机位置同步
	camera.position = owner.find_child("Player").position
	# 人物位置同步 TODO 待人物动画确定后需要计算人物偏移量
	location.position = owner.find_child("Player").position
	# TODO 显示周边人物、NPC、怪物
	
