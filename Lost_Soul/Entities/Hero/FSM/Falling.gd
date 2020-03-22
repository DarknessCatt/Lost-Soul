extends "BasicMove.gd"

const GRAV : int = 5000
const MAX_GRAV : int = 1000

func _ready():
	#Overridable Vars
	##Movement Vars
	FRICTION = 0.9

	##Animation Vars
	MOVE_ANIMATION = "Walking"
	REST_ANIMATION = "Rest"

func enter(_Player : KinematicBody2D) -> void:

	.enter(_Player)

	if _Player.speed.y < 0:
		_Player.speed.y /= 2
	else:
		_Player.speed.y = 20

func exit(_Player : KinematicBody2D) -> void:
	_Player.speed.y = 10

func update(_Player: KinematicBody2D, delta : float) -> void:
	_Player.speed.y += GRAV*delta

	.update(_Player, delta)

	if _Player.is_on_floor():
		_Player._change_state($"../OnGround")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	.input(_Player, event)
