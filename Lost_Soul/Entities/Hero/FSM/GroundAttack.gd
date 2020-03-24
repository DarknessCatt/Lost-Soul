extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)
const MOVE_SPEED : int = 800

var attacking : bool = false
var can_cancel : bool = false
var attack_buffered : bool = false

onready var buffer : Node = $"../Buffer"
onready var combo_info : Array = [["Jab1", $Jab1], ["Jab2", $Jab2], ["Jab3", $Jab3]]

func enter(_Player : KinematicBody2D) -> void:
	_Player.speed.x = 0
	self.attack(_Player)

func update(_Player: KinematicBody2D, delta : float) -> void:

	_Player.speed.x = MOVE_SPEED*delta*sign(_Player.body.scale.x)

	_Player.move_and_slide(_Player.speed, NORMAL)

	if can_cancel:

		if attack_buffered:
			attack(_Player)

		elif Input.is_action_pressed("hero_left") \
			or Input.is_action_pressed("hero_right"):
			_Player._change_state($"../OnGround")

	elif not attacking:
		buffer._attack_end()
		_Player._change_state($"../OnGround")

func attack(_Player : KinematicBody2D):
	$cancel.stop()
	$attack_input.stop()

	attack_buffered = false
	can_cancel = false

	var num = buffer.attack_num
	var attack = combo_info[num]

	_Player._change_anim(attack[0])
	attack[1].start()
	attacking = true

	if num+1 == len(combo_info):
		num = -1

	buffer._register_attack(num+1)

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_pressed("hero_attack"):
		if can_cancel:
			attack(_Player)
		else:
			attack_buffered = true
			$attack_input.start()

func _on_Attack_timeout():
	can_cancel = true
	$cancel.start()

func _on_cancel_timeout():
	attacking = false
	can_cancel = false

func _on_attack_input_timeout():
	attack_buffered = false
