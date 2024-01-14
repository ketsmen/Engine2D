#*****************************************************************************
# @file    layer.gd
# @author  MakerYang
#*****************************************************************************
extends CanvasLayer

@onready var camera = $MiniMap/Main/Show/Camera
@onready var location = $MiniMap/Main/Show/Location

func _process(_delta):
	camera.position = owner.find_child("Player").position
	location.position = owner.find_child("Player").position
	# TODO 显示周边人物、NPC、怪物
	
