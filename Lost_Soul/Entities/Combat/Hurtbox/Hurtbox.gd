extends Area2D

enum IDS {None, Player, Enemies, Hazard, Other}

export(IDS) var Id : int = 0
export(NodePath) var Character : NodePath

onready var Char_Node : Node2D = get_node(Character)
const HIT_DIST : int = 20

func _on_Hitbox_entered(area):
	if self.Id != area.Id:
		if not Char_Node.invencible:
			var hit_dir = (area.global_position - self.global_position).normalized()
			$OnHitEffect.position = hit_dir*(self.get_child(1).shape.radius+HIT_DIST)
			$OnHitEffect.frame = 0
			$OnHitEffect.play()
			Char_Node._hit(area.Damage, area.Force, area.Direction)
