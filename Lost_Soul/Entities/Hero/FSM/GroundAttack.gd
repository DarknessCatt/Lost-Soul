extends "State.gd"

const NORMAL : Vector2 = Vector2(0, -1)

var attacking : bool = false

func enter(_Player : KinematicBody2D) -> void:
	_Player.speed.x = 0
	_Player._change_anim("Jab1")
	attacking = true
	$Jab1.start()

func update(_Player: KinematicBody2D, delta : float) -> void:
	_Player.move_and_slide(_Player.speed, NORMAL)

	if not attacking:
		_Player._change_state($"../OnGround")

func _on_Jab1_timeout():
	attacking = false
