extends Node2D

var data = {
	"status": false,
	"player": {
		"action": "stand",
		"speed": 0,
		"angle": 0,
		"step_length": 0,
		"position": Vector2.ZERO,
		"target_position": Vector2.ZERO,
		"last_position": Vector2.ZERO
	},
	"mouse": {
		"position": Vector2.ZERO,
	},
	"is_move": false,
	"is_shift": false,
	"is_ctrl": false,
	"is_walking": false,
	"is_running": false
}

func _process(_delta):
	# 获取窗口的边界
	var viewport_rect = get_viewport_rect()
	# 获取鼠标的位置
	var viewport_mouse_position = get_viewport().get_mouse_position()
	# 检查鼠标是否在窗口内
	if !viewport_rect.has_point(viewport_mouse_position):
		# 如果鼠标不在窗口内则保持默认状态
		data["player"]["action"] = "stand"
		data["player"]["speed"] = 0
		data["status"] = false
	else:
		# 监听按键的状态
		if Input.is_action_pressed("walking"):
			data["is_walking"] = true
			data["player"]["step_length"] = 50
			data["player"]["speed"] = 70
		if Input.is_action_pressed("running"):
			data["is_running"] = true
			data["player"]["step_length"] = 100
			data["player"]["speed"] = 140
		if Input.is_action_pressed("shift"):
			data["is_shift"] = true
			data["player"]["step_length"] = 0
			data["player"]["speed"] = 0
		if Input.is_action_pressed("ctrl"):
			data["is_ctrl"] = true
			data["player"]["step_length"] = 0
			data["player"]["speed"] = 0
		if Input.is_action_just_released("walking"):
			data["is_walking"] = false
			data["player"]["step_length"] = 0
			data["player"]["speed"] = 0
		if Input.is_action_just_released("running"):
			data["is_running"] = false
			data["player"]["step_length"] = 0
			data["player"]["speed"] = 0
		if Input.is_action_just_released("shift"):
			data["is_shift"] = false
			data["player"]["step_length"] = 0
			data["player"]["speed"] = 0
		if Input.is_action_just_released("ctrl"):
			data["is_ctrl"] = false
			data["player"]["step_length"] = 0
			data["player"]["speed"] = 0

# 获取控制状态
func get_status() -> bool:
	return data["status"]

# 设置控制状态
func set_status(status: bool):
	data["status"] = status

# 获取移动状态
func get_move() -> bool:
	return data["is_move"]

# 设置移动状态
func set_move(status: bool):
	data["is_move"] = status

# 获取动作
func get_action() -> String:
	if data["status"]:
		if !data["is_shift"] and !data["is_ctrl"] and data["is_walking"]:
			data["player"]["action"] = "walking"
		if !data["is_shift"] and !data["is_ctrl"] and data["is_running"]:
			data["player"]["action"] = "running"
		if data["is_shift"] and !data["is_ctrl"] and data["is_walking"]:
			data["player"]["action"] = "attack"
		if !data["is_shift"] and data["is_ctrl"] and data["is_walking"]:
			data["player"]["action"] = "pickup"
	return data["player"]["action"]

# 更新动作
func update_action(action: String):
	data["player"]["action"] = action

# 获取步长
func get_step_length() -> int:
	return data["player"]["step_length"]

# 获取速度
func get_speed() -> int:
	return data["player"]["speed"]

# 更新速度
func update_speed(speed: int):
	data["player"]["speed"] = speed
	
# 获取角度
func get_angle() -> int:
	return data["player"]["angle"]

# 更新速度
func update_angle(angle: int):
	data["player"]["angle"] = angle

# 更新玩家位置
func update_player_position(position_data: Vector2) -> Vector2:
	data["player"]["position"] = position_data
	return data["player"]["position"]

# 更新玩家目标位置
func update_player_target_position(position_data: Vector2) -> Vector2:
	data["player"]["target_position"] = position_data
	return data["player"]["target_position"]
	
# 更新玩家最后位置
func update_player_last_position(position_data: Vector2):
	data["player"]["last_position"] = position_data

# 更新鼠标位置
func update_mouse_position(position_data: Vector2) -> Vector2:
	data["mouse"]["position"] = position_data
	return data["mouse"]["position"]

# 更新鼠标角度
func update_mouse_angle(position_data: Vector2) -> int:
	# 获取鼠标的角度(以弧度为单位)并捕捉最接近45度的倍数(0,1,2,3,4,-4,-3,-2,-1)
	var angle = snapped(position_data.angle(), PI/4) / (PI/4)
	# 将获取的倍数分别除以45度(0,1,2,3,4,5,6,7)
	data["player"]["angle"] = wrapi(int(angle), 0, 8)
	return data["player"]["angle"]

# 获取方向量
func get_direction() -> Vector2:
	var direction = Vector2(cos(data["player"]["angle"] * PI/4), sin(data["player"]["angle"] * PI/4))
	# 修正角方向偏移 TODO 仍有轻微偏移
	#if data["player"]["angle"] == 1:
		#direction = Vector2(0.7, 0.4)
	#if data["player"]["angle"] == 3:
		#direction = Vector2(-0.7, 0.4)
	#if data["player"]["angle"] == 5:
		#direction = Vector2(-0.7, -0.4)
	#if data["player"]["angle"] == 7:
		#direction = Vector2(0.7, -0.4)
	return direction
