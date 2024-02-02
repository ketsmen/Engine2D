#*****************************************************************************
# @file    loading.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 实例化节点树中的资源
@onready var progress:TextureProgressBar = $Progress/Texture

# 初始化节点数据
var is_loader = false

func _ready() -> void:
	# 初始化加载状态
	is_loader = false
	# 初始化进度条
	progress.value = 0

func _process(_delta) -> void:
	if is_loader:
		var loader_status = false
		for i in range(len(Loader.get_default_path_list())):
			Loader.load_resource(Loader.get_default_path(i))
			var status = Loader.get_resource_status(Loader.get_default_path(i))
			progress.value += (status["progress"][0] * 100) / len(Loader.get_default_path_list())
			if status["status"] and i == (len(Loader.get_default_path_list()) - 1):
				loader_status = true
		await get_tree().create_timer(0.5).timeout
		if loader_status:
			set_process(false)
			await get_tree().create_timer(0.5).timeout
			var change_scene_status = get_tree().change_scene_to_file(Loader.get_world_scene_path())
			if change_scene_status == OK:
				is_loader = false
				visible = false
			else:
				get_parent().on_message("资源加载失败，请重新尝试", 0)

func on_loader() -> void:
	if !is_loader:
		is_loader = true
