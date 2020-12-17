extends Area2D

enum IDS {None, Player, Enemies, Hazard, Other}
enum type {Directional, Radial}

export(NodePath) var Body : NodePath
onready var body_node : Node2D = get_node(Body)

export(IDS) var Id : int = 0
export(int) var Damage : int = 0
export(int) var Force : int = 0
export (type) var Knockback_Type : int = 0
export(Vector2) var Direction : Vector2 = Vector2(0,0) setget , get_direction

func get_direction():
	if body_node.scale.x == 1:
		return Direction

	else:
		return Vector2(-Direction.x, Direction.y)
