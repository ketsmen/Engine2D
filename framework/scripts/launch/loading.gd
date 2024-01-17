#*****************************************************************************
# @file    loading.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var progress:TextureProgressBar = $Progress/Texture

# 初始化节点数据
var world_scene_path = "res://framework/scenes/world/world.tscn"
var player_current_map = ""
var loader_progress = []
var loader_status = 0
var is_loader = false

func _ready():
	is_loader = false
	player_current_map = Global.get_player_current_map()
	ResourceLoader.load_threaded_request(world_scene_path)

func _process(_delta):
	if is_loader:
		# 加载世界场景
		loader_status = ResourceLoader.load_threaded_get_status(world_scene_path, loader_progress)
		progress.value = 10
		if loader_status == ResourceLoader.THREAD_LOAD_LOADED:
			# 加载地图
			loader_progress = []
			ResourceLoader.load_threaded_request(player_current_map)
			loader_status = ResourceLoader.load_threaded_get_status(player_current_map, loader_progress)
			progress.value += (loader_progress[0] * 100) - 10
			if loader_status == ResourceLoader.THREAD_LOAD_LOADED:
				set_process(false)
				await get_tree().create_timer(0.5).timeout
				get_tree().change_scene_to_file(world_scene_path)
				is_loader = false
				visible = false

func on_loader():
	if !is_loader:
		is_loader = true
