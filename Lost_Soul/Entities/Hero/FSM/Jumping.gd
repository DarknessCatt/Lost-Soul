extends "BasicMove.gd"

const GRAV : int = 2300

const JUMP_FORCE = 1100

onready var buffer : Node = $"../Buffer"

func _ready():
	MOVE_ANIMATION = "Jumping"
	REST_ANIMATION = "Jumping"

func enter(_Player : KinematicBody2D) -> void:
	.enter(_Player)

	_Player.speed.y = -JUMP_FORCE

	if buffer.attack_buffered and buffer.can_attack:
		_Player._change_state($"../AirAttack")

	elif not Input.is_action_pressed("hero_jump"):
		_Player._change_state($"../Falling")

func update(_Player: KinematicBody2D, delta : float) -> void:
	_Player.speed.y += GRAV*delta

	.update(_Player, delta)

	if _Player.speed.y > 0 or _Player.is_on_ceiling():
		_Player.speed.y = 0
		_Player._change_state($"../Falling")

	elif buffer.attack_buffered:
		_Player._change_state($"../AirAttack")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_released("hero_jump"):
		_Player._change_state($"../Falling")

	elif event.is_action_pressed("hero_attack"):
		_Player._change_state($"../AirAttack")

	else:
		.input(_Player, event)
