extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)
const MOVE_SPEED : int = 800

var attacking : bool = false
var can_cancel : bool = false
var attack_buffered : bool = false
var jump_buffered : bool = false

onready var buffer : Node = $"../Buffer"
onready var combo_info : Array = [["Jab1", $Jab1], ["Jab2", $Jab2], \
								["Jab3", $Jab3], ["UpTilt", $UpTilt]]

func enter(_Player : KinematicBody2D) -> void:
	$attack_input.stop()
	$jump_input.stop()
	$cancel.stop()

	jump_buffered = false
	attack_buffered = false
	can_cancel = false

	_Player.speed.x = 0
	self.attack(_Player)

func exit(_Player: KinematicBody2D) -> void:
	_Player._clear_attack_polys()
	_Player._disable_hitboxes()

func update(_Player: KinematicBody2D, delta : float) -> void:

	_Player.speed.x = MOVE_SPEED*delta*sign(_Player.body.scale.x)

	_Player.move_and_slide(_Player.speed, NORMAL)

	if can_cancel:

		if jump_buffered:
			_Player._change_state($"../Jumping")

		elif attack_buffered:
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

	if Input.is_action_pressed("hero_up"):
		num = 3

	var attack = combo_info[num]

	_Player._change_anim(attack[0])
	attack[1].start()
	attacking = true

	if num+1 >= 3:
		num = -1

	buffer._register_attack(num+1)

func input(_Player: KinematicBody2D, event : InputEvent) -> void:
	if event.is_action_pressed("hero_attack"):
		if can_cancel:
			attack(_Player)
		else:
			attack_buffered = true
			$attack_input.start()

	elif event.is_action("hero_jump"):
		if can_cancel:
			_Player._change_state($"../Jumping")
		else:
			jump_buffered = true
			$jump_input.start()

func _on_Attack_timeout():
	can_cancel = true
	$cancel.start()

func _on_cancel_timeout():
	attacking = false
	can_cancel = false

func _on_attack_input_timeout():
	attack_buffered = false

func _on_jump_input_timeout():
	jump_buffered = false
