#*****************************************************************************
# @file    walking.gd
# @author  MakerYang
#*****************************************************************************
extends StateBase

# 定义玩家节点
@export var player:Player

# 定义攻击状态锁
var attack_status_lock:bool

func _ready() -> void:
	player = get_parent().get_parent()

func enter() -> void:
	super.enter()
	player.player_action = "attack"
	attack_status_lock = true
	print("[攻击状态]")

func process_update(delta: float) -> void:
	super.process_update(delta)

func physics_process_update(delta: float) -> void:
	super.physics_process_update(delta)
	# 切换玩家状态
	player.on_switch_action_status()
	# 状态检测
	if Input.is_action_just_released("shift"):
		attack_status_lock = false
	if !attack_status_lock and player.player_clothe.frame == 5:
		state_machine.change_state("Stand")
