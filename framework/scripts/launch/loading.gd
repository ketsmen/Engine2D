#*****************************************************************************
# @file    loading.gd
# @author  MakerYang
#*****************************************************************************
extends Control

@onready var progress:TextureProgressBar = $Progress/Texture

# 初始化节点数据
var loader_path = "res://framework/scenes/world/world.tscn"
var loader_progress = []
var loader_status = 0
var is_loader = false

func _ready():
	is_loader = false
	progress.max_value = 100
	ResourceLoader.load_threaded_request(loader_path)

func _process(_delta):
	if is_loader:
		loader_status = ResourceLoader.load_threaded_get_status(loader_path, loader_progress)
		progress.value = loader_progress[0] * 100
		if loader_status == ResourceLoader.THREAD_LOAD_LOADED:
			set_process(false)
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file(loader_path)

func on_loader():
	if !is_loader:
		is_loader = true
