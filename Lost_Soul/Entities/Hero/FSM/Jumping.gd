extends "BasicMove.gd"

const GRAV : int = 4000

const JUMP_FORCE = 1300

func _ready():
	#Overridable Vars
	##Movement Vars
	FRICTION = 0.9

	##Animation Vars
	MOVE_ANIMATION = "Jumping"
	REST_ANIMATION = "Jumping"

func enter(_Player : KinematicBody2D) -> void:
	_Player.speed.y -= JUMP_FORCE
	_Player._change_anim("Jumping")
	if not Input.is_action_pressed("hero_jump"):
		_Player.speed.y /= 1.5

	.enter(_Player)

func update(_Player: KinematicBody2D, delta : float) -> void:
	_Player.speed.y += GRAV*delta

	.update(_Player, delta)

	if _Player.speed.y > 0 or _Player.is_on_ceiling():
		_Player.speed.y = 0
		_Player._change_state($"../Falling")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_released("hero_jump"):
		_Player._change_state($"../Falling")

	elif event.is_action_pressed("hero_attack"):
		_Player._change_state($"../AirAttack")

	else:
		.input(_Player, event)
