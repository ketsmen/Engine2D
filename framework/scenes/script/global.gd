extends Node

func _ready():
	print("Global Init")
	# 限制窗口最小尺寸
	DisplayServer.window_set_min_size(Vector2(1280, 720))
	pass

func _process(_delta):
	pass
