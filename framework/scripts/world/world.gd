#*****************************************************************************
# @file    world.gd
# @author  MakerYang
#*****************************************************************************
extends Node2D

# 初始化节点数据
var current_scene

func _ready():
	current_scene = get_tree().current_scene
	# 加载玩家所在地图资源
	on_loader_map(Global.data["world"]["current_map"])
	# 创建玩家组
	var players_node = Node2D.new()
	players_node.name = "Players"
	current_scene.add_child(players_node)
	current_scene.move_child(players_node, 1)
	# 创建怪物组
	var monsters_node = Node2D.new()
	monsters_node.name = "Monsters"
	current_scene.add_child(monsters_node)
	current_scene.move_child(monsters_node, 2)
	# 创建NPC组
	var npcs_node = Node2D.new()
	npcs_node.name = "Npcs"
	current_scene.add_child(npcs_node)
	current_scene.move_child(npcs_node, 3)
	# 加载玩家资源
	on_loader_player()
	# 加载UI资源
	on_loader_layer()

func on_loader_layer():
	# 更新layer层级
	current_scene.move_child($Layer, 5)

func on_loader_player():
	# 玩家资源路径
	var player_path = "res://framework/scenes/world/player/player.tscn"
	# 加载玩家资源
	var player_loader = load(player_path).instantiate()
	player_loader.name = "Player"
	# 将玩家资源添加到场景中
	current_scene.add_child(player_loader)
	# 设置玩家资源层级
	current_scene.move_child(player_loader, 4)

func on_loader_map(map_id: String):
	# 地图资源路径
	var map_path = Global.data["config"]["map_path"] + map_id + ".tscn"
	# 加载地图资源
	var map_loader = load(map_path).instantiate()
	map_loader.name = "Map"
	# 将地图资源添加到场景中
	current_scene.add_child(map_loader)
	# 设置地图资源层级
	current_scene.move_child(map_loader, 0)
