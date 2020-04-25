extends "BasicMove.gd"

onready var buffer : Node = $"../Buffer"

func _ready():
	#Overridable Vars
	##Animation Vars
	MOVE_ANIMATION = "Walking"
	REST_ANIMATION = "Rest"

func enter(_Player : KinematicBody2D) -> void:
	if not _Player.is_on_floor():
		_Player._change_state($"../Falling")

	elif buffer.jump_buffered:
		_Player._change_state($"../Jumping")

	elif buffer.attack_buffered and buffer.can_attack:
		_Player._change_state($"../GroundAttack")

	else:
		_Player.speed.y = 10
		.enter(_Player)

func update(_Player: KinematicBody2D, delta : float) -> void:

	.update(_Player, delta)

	if buffer.attack_buffered and buffer.can_attack:
		_Player._change_state($"../GroundAttack")

	elif not _Player.is_on_floor():
		buffer._coyote_timer()
		_Player._change_state($"../Falling")


func input(_Player: KinematicBody2D, event : InputEvent) -> void:

	if event.is_action_pressed("hero_jump"):
		_Player._change_state($"../Jumping")

	elif event.is_action_pressed("hero_attack"):
		if buffer.can_attack:
			_Player._change_state($"../GroundAttack")

		else:
			buffer._buffer_attack()

	else:
		.input(_Player, event)
