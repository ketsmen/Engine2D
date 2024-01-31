#*****************************************************************************
# @file    action.gd
# @author  MakerYang
#*****************************************************************************
extends Control

# 初始化数据结构
var data = {
	"control_status": false,
	"action": "stand",
	"angle": 0,
	"speed": 0,
	"step": 0,
	"mouse": {
		"position": Vector2.ZERO
	},
	"tilemap_grid_size": Vector2(48, 32),
	"enter_status": false,
	"move_status": false
}

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		print(event.is_action_pressed("shift"))

func _process(_delta):
	# 获取窗口的边界
	var viewport_rect = get_viewport_rect()
	# 获取鼠标的位置
	var viewport_mouse_position = get_viewport().get_mouse_position()
	# 如果鼠标是否在窗口内
	if viewport_rect.has_point(viewport_mouse_position) and data["control_status"]:
		# 按键检测
		if Input.is_action_pressed("walking") and !Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
			data["action"] = "walking"
			data["step"] = 1
		if Input.is_action_pressed("running") and !Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
			data["action"] = "running"
			data["step"] = 2
		if Input.is_action_pressed("walking") and Input.is_action_pressed("shift") and !Input.is_action_pressed("ctrl"):
			data["action"] = "attack"
		if Input.is_action_pressed("walking") and !Input.is_action_pressed("shift") and Input.is_action_pressed("ctrl"):
			data["action"] = "pickup"
		if Input.is_action_pressed("skill_f1") or Input.is_action_pressed("skill_f2") or Input.is_action_pressed("skill_f3") or Input.is_action_pressed("skill_f4") or Input.is_action_pressed("skill_f5") or Input.is_action_pressed("skill_f6") or Input.is_action_pressed("skill_f7") or Input.is_action_pressed("skill_f8") or Input.is_action_pressed("skill_f9") or Input.is_action_pressed("skill_f10") or Input.is_action_pressed("skill_f11") or Input.is_action_pressed("skill_f12"):
			data["enter_status"] = true
			data["action"] = "launch"
		# 方向检测
		if 	data["action"] in ["walking", "running", "attack", "pickup", "launch"] and !data["move_status"]:
			data["angle"] = calculation_angle()
		# 移动速度检测
		if data["mouse"]["position"].length() > 50:
			if data["action"] == "walking":
				data["speed"] = 80
			if data["action"] == "running":
				data["speed"] = 160
		else:
			data["action"] = "stand"
			data["speed"] = 0

# 获取控制状态
func get_control_status() -> bool:
	return data["control_status"]

# 更新并返回控制状态
func update_control_status(status: bool) -> bool:
	data["control_status"] = status
	return data["control_status"]

# 获取按键状态
func get_enter_status() -> bool:
	return data["enter_status"]

# 更新按键状态
func update_enter_status(status: bool) -> bool:
	data["enter_status"] = status
	return data["enter_status"]

# 获取移动状态
func get_move_status() -> bool:
	return data["move_status"]

# 更新移动状态
func update_move_status(status: bool) -> bool:
	data["move_status"] = status
	return data["move_status"]

# 更新鼠标位置
func update_mouse_position(mouse_position: Vector2):
	data["mouse"]["position"] = mouse_position

# 获取当前动作名称
func get_action_name() -> String:
	return data["action"]

# 更新并返回当前动作
func update_action_name(action: String) -> String:
	data["action"] = action
	return data["action"]

# 获取当前动作
func get_action() -> String:
	return str(data["angle"]) + "_" + data["action"]

# 计算方向
func calculation_angle() -> int:
	data["angle"] = wrapi(int(snapped(data["mouse"]["position"].angle(), PI/4) / (PI/4)), 0, 8)
	return data["angle"]

# 获取当前角度
func get_angle() -> int:
	return data["angle"]

# 更新并返回当前角度
func update_angle(angle: int) -> int:
	data["angle"] = angle
	return data["angle"]

# 获取当前速度
func get_speed() -> int:
	return data["speed"]

# 获取目标位置
func get_target_position(player_position: Vector2) -> Vector2:
	var target_position = Vector2.ZERO
	if data["angle"] == 0:
		target_position = Vector2(player_position.x + (data["step"] * data["tilemap_grid_size"].x), player_position.y)
	if data["angle"] == 1:
		target_position = Vector2(player_position.x + (data["step"] * data["tilemap_grid_size"].x), player_position.y + (data["step"] * data["tilemap_grid_size"].y))
	if data["angle"] == 2:
		target_position = Vector2(player_position.x, player_position.y + (data["step"] * data["tilemap_grid_size"].y))
	if data["angle"] == 3:
		target_position = Vector2(player_position.x - (data["step"] * data["tilemap_grid_size"].x), player_position.y + (data["step"] * data["tilemap_grid_size"].y))
	if data["angle"] == 4:
		target_position = Vector2(player_position.x - (data["step"] * data["tilemap_grid_size"].x), player_position.y)
	if data["angle"] == 5:
		target_position = Vector2(player_position.x - (data["step"] * data["tilemap_grid_size"].x), player_position.y - (data["step"] * data["tilemap_grid_size"].y))
	if data["angle"] == 6:
		target_position = Vector2(player_position.x, player_position.y - (data["step"] * data["tilemap_grid_size"].y))
	if data["angle"] == 7:
		target_position = Vector2(player_position.x + (data["step"] * data["tilemap_grid_size"].x), player_position.y - (data["step"] * data["tilemap_grid_size"].y))
	return target_position
	
# 恢复默认动作
func restore_default_actions():
	data["action"] = "stand"
	data["speed"] = 0
