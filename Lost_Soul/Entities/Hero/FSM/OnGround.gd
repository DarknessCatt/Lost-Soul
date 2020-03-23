extends "BasicMove.gd"

func _ready():
	#Overridable Vars
	##Animation Vars
	MOVE_ANIMATION = "Walking"
	REST_ANIMATION = "Rest"

func enter(_Player : KinematicBody2D) -> void:
	if $"../Buffer".jump_buffered:
		_Player._change_state($"../Jumping")
	else:
		.enter(_Player)

func update(_Player: KinematicBody2D, delta : float) -> void:

	.update(_Player, delta)

	if not _Player.is_on_floor():
		$"../Buffer"._coyote_timer()
		_Player._change_state($"../Falling")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:

	if event.is_action_pressed("hero_jump"):
		_Player._change_state($"../Jumping")

	elif event.is_action_pressed("hero_attack"):
		_Player._change_state($"../GroundAttack")

	else:
		.input(_Player, event)
