extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)
const MOVE_SPEED : int = 800

var attacking : bool = false
var can_cancel : bool = false
var attack_buffered : bool = false

onready var buffer : Node = $"../Buffer"
onready var combo_info : Array = [["AirJab1", $Jab1], ["AirJab2", $Jab2]]

func enter(_Player : KinematicBody2D) -> void:
	$attack_input.stop()
	$cancel.stop()

	attack_buffered = false
	can_cancel = false

	_Player.speed.x = 0
	_Player.speed.y = 10

	self.attack(_Player)

func update(_Player: KinematicBody2D, delta : float) -> void:

	_Player.speed.x = MOVE_SPEED*delta*sign(_Player.body.scale.x)

	_Player.move_and_slide(_Player.speed, NORMAL)

	if _Player.is_on_floor():
		_Player._change_state($"../OnGround")

	if can_cancel and attack_buffered:
			attack(_Player)

	elif not attacking:
		buffer._attack_end()
		_Player._change_state($"../Falling")

func attack(_Player : KinematicBody2D):
	$cancel.stop()
	$attack_input.stop()

	attack_buffered = false
	can_cancel = false

	var num = buffer.air_attack_num

#	if Input.is_action_pressed("hero_up"):
#		num = 3

	var attack = combo_info[num]

	_Player._change_anim(attack[0])
	attack[1].start()
	attacking = true

	if num+1 >= 2:
		num = -1

	buffer._register_air_attack(num+1)

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
