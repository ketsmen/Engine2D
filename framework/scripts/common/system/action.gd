#*****************************************************************************
# @file    action.gd
# @author  MakerYang
#*****************************************************************************
extends Control

var data = {
	"control_status": false,
	"action": "stand",
	"move": false,
	"speed": 0,
	"mouse": {
		"position": Vector2.ZERO
	}
}

func _process(_delta):
	# 获取窗口的边界
	var viewport_rect = get_viewport_rect()
	# 获取鼠标的位置
	var viewport_mouse_position = get_viewport().get_mouse_position()
	# 如果鼠标是否在窗口内
	if viewport_rect.has_point(viewport_mouse_position) and data["control_status"]:
		# 当前鼠标位置
		data["mouse"]["position"] = get_local_mouse_position()
		# 按键检测
		if Input.is_action_pressed("walking") and !Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
			data["action"] = "walking"
			data["speed"] = 70
		if Input.is_action_pressed("running") and !Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
			data["action"] = "running"
			data["speed"] = 160
		if !Input.is_action_pressed("walking") and Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
			data["action"] = "attack_stand"
		if Input.is_action_pressed("walking") and Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
			data["action"] = "attack"
		if Input.is_action_pressed("walking") and !Input.is_action_pressed("shift") and Input.is_action_pressed("ctrl"):
			data["action"] = "pickup"
		# 移动检测
		if data["speed"] > 0 and data["mouse"]["position"].length() > 10:
			data["move"] = true
		else:
			data["move"] = false

# 获取控制状态
func get_control_status() -> bool:
	return data["control_status"]

# 更新并返回控制状态
func update_control_status(status: bool) -> bool:
	data["control_status"] = status
	return data["control_status"]

# 获取当前动作
func get_action() -> String:
	return data["action"]

# 更新并返回当前动作
func update_action(action: String) -> String:
	data["action"] = action
	return data["action"]
