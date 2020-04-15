extends Area2D

enum IDS {None, Player, Enemies, Hazard, Other}

export(IDS) var Id : int = 0
export(NodePath) var Character : NodePath

onready var Char_Node : Node2D = get_node(Character)

func _on_Hitbox_entered(area):
	if self.Id != area.Id:
		Char_Node._hit(area.Damage, area.Force, area.Direction)
