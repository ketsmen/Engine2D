#*****************************************************************************
# @file    world.gd
# @author  MakerYang
#*****************************************************************************
extends Node2D

# 实例化节点树中的资源
@onready var layer:CanvasLayer = $Layer

# 初始化节点数据
var current_scene:Node2D

func _ready():
	current_scene = get_tree().current_scene
	# 加载玩家当前地图资源
	on_loader_map()
	# 创建用户存储节点
	create_user_node()
	# 创建怪物存储节点
	create_monster_node()
	# 创建NPC存储节点
	create_npc_node()
	# 加载玩家资源
	on_loader_player()
	# 加载UI资源
	on_loader_layer()

func on_loader_map():
	# 加载地图资源
	var map_loader = load(Player.get_map()).instantiate()
	map_loader.name = "Map"
	# 将地图资源添加到场景中
	current_scene.add_child(map_loader)
	# 设置地图资源层级
	current_scene.move_child(map_loader, 0)

func create_user_node():
	var player_node = Node2D.new()
	player_node.name = "User"
	current_scene.add_child(player_node)
	current_scene.move_child(player_node, 1)

func create_monster_node():
	var monster_node = Node2D.new()
	monster_node.name = "Monster"
	current_scene.add_child(monster_node)
	current_scene.move_child(monster_node, 2)

func create_npc_node():
	var npc_node = Node2D.new()
	npc_node.name = "Npc"
	current_scene.add_child(npc_node)
	current_scene.move_child(npc_node, 3)
	
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
	# 初始化玩家位置
	player_loader.position = get_child(0).get_child(0).map_to_local(Player.get_coordinate_value())

func on_loader_layer():
	# 更新layer层级
	current_scene.move_child(layer, 5)

func on_return_launch():
	var launch_path = "res://framework/scenes/launch/launch.tscn"
	Utils.data["source"] = "world"
	get_tree().change_scene_to_file(launch_path)
