#*****************************************************************************
# @file    world.gd
# @author  MakerYang
#*****************************************************************************
extends Node2D

func _ready():
	# 动态加载地图
	var map_path = Global.data["config"]["map_path"] + Global.data["world"]["current_map"] + ".tscn"
	var map_loader = load(map_path).instantiate()
	# 获取当前场景
	var current_scene = get_tree().current_scene
	# 将地图添加到场景中
	current_scene.add_child(map_loader)
	# 将地图设置为最底层
	current_scene.move_child(map_loader, 0)

func _process(_delta):
	# 同步小地图
	pass
