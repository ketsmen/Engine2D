#*****************************************************************************
# @file    show.gd
# @author  MakerYang
#*****************************************************************************
extends SubViewport

@onready var camera = $Camera

func _ready():
	# 动态加载地图
	var map_path = Global.data["config"]["map_path"] + Global.data["world"]["current_map"] + ".tscn"
	var map_loader = load(map_path).instantiate()
	# 获取当前场景
	var current_scene = get_tree().current_scene
	# 查找小地图渲染节点
	var map_box = current_scene.find_child("Show")
	# 将地图添加到场景中
	map_box.add_child(map_loader)
	# 将地图设置为最底层
	map_box.move_child(map_loader, 0)
