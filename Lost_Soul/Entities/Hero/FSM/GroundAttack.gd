extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)
const MOVE_SPEED : int = 900

var attacking : bool = false
var attack_buffered : bool = false

onready var buffer : Node = $"../Buffer"
onready var combo_info : Array = [["Jab1", $Jab1], ["Jab2", $Jab2], ["Jab3", $Jab3]]

func enter(_Player : KinematicBody2D) -> void:
	_Player.speed.x = 0
	self.attack(_Player)

func update(_Player: KinematicBody2D, delta : float) -> void:
	var speed = 0

	if Input.is_action_pressed("hero_right"):
		speed += MOVE_SPEED*delta

	if Input.is_action_pressed("hero_left"):
		speed -= MOVE_SPEED*delta

	_Player.speed.x = speed

	_Player.move_and_slide(_Player.speed, NORMAL)

	if not attacking:
		if attack_buffered:
			attack(_Player)
			attack_buffered = false
		else:
			buffer._attack_end()
			_Player._change_state($"../OnGround")

func attack(_Player : KinematicBody2D):
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
		attack_buffered = true

func _on_Jab1_timeout():
	attacking = false

func _on_Jab2_timeout():
	attacking = false

func _on_Jab3_timeout():
	attacking = false
