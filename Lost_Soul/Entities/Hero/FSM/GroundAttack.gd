extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)
const MOVE_SPEED : int = 800

onready var buffer : Node = $"../Buffer"

var attack_finished : bool = false
var left_attack : bool = false

func enter(_Player : KinematicBody2D) -> void:
	attack_finished = false

	if Input.is_action_pressed("hero_up"):
		attack_finished = true

	else:
		var attack = "Jab_Right"

		if left_attack: attack = "Jab_Left"
		left_attack = not left_attack

		_Player._change_anim(attack)
		$Jab.start()

func exit(_Player: KinematicBody2D) -> void:
	_Player._clear_attack_polys()
	_Player._disable_hitboxes()

func update(_Player: KinematicBody2D, delta : float) -> void:
	if attack_finished:
		_Player._change_state($"../OnGround")

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action("hero_jump"):
		buffer._buffer_jump()

func _on_Attack_timeout():
	buffer._attack_end()
	attack_finished = true
