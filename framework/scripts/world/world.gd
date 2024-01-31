#*****************************************************************************
# @file    world.gd
# @author  MakerYang
#*****************************************************************************
extends Node2D

# 实例化节点树中的资源
@onready var layer:CanvasLayer = $Layer

func _ready():
	Global.world_node = get_tree().current_scene
	# 加载玩家当前地图资源
	on_loader_map()
	# 创建用户存储节点
	create_user_node()
	# 创建怪物存储节点
	create_monster_node()
	# 创建NPC存储节点
	create_npc_node()
	# 加载UI资源
	on_loader_layer()
	# 加载玩家资源
	on_loader_player()

func on_loader_map():
	# 加载地图资源
	var map_loader = Loader.get_resource_loaded(Loader.get_map_scene_path()).instantiate()
	map_loader.name = "Map"
	# 将地图资源添加到场景中
	Global.world_node.add_child(map_loader)
	# 设置地图资源层级
	Global.world_node.move_child(map_loader, 0)
	# 添加到Global便于后续使用
	Global.map_node = map_loader

func create_user_node():
	# 创建玩家存储节点
	var player_node = Node2D.new()
	player_node.name = "Player"
	# 将玩家存储节点添加到场景中
	Global.world_node.add_child(player_node)
	# 设置玩家存储节点层级
	Global.world_node.move_child(player_node, 1)
	# 添加到Global便于后续使用
	Global.player_node = player_node

func create_monster_node():
	# 创建怪物存储节点
	var monster_node = Node2D.new()
	monster_node.name = "Monster"
	# 将怪物存储节点添加到场景中
	Global.world_node.add_child(monster_node)
	# 设置怪物存储节点层级
	Global.world_node.move_child(monster_node, 2)
	# 添加到Global便于后续使用
	Global.monster_node = monster_node

func create_npc_node():
	# 创建NPC存储节点
	var npc_node = Node2D.new()
	npc_node.name = "Npc"
	# 将NPC存储节点添加到场景中
	Global.world_node.add_child(npc_node)
	# 设置NPC存储节点层级
	Global.world_node.move_child(npc_node, 3)
	# 添加到Global便于后续使用
	Global.npc_node = npc_node

func on_loader_layer():
	# 更新layer层级
	Global.world_node.move_child(layer, 4)

func on_loader_player():
	# 加载玩家资源
	var player_loader = Loader.get_resource_loaded(Loader.get_player_scene_path()).instantiate()
	player_loader.name = Global.get_account_player_token()
	# 绑定玩家Token
	player_loader.set_meta("token", Global.get_account_player_token())
	# 将玩家资源添加到场景中
	Global.player_node.add_child(player_loader)
	# 添加到Global便于后续使用
	Global.player = player_loader

func on_return_launch():
	var launch_path = "res://framework/scenes/launch/launch.tscn"
	Utils.data["source"] = "world"
	get_tree().change_scene_to_file(launch_path)
