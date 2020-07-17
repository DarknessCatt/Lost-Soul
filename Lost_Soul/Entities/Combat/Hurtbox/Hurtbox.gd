extends Area2D

enum IDS {None, Player, Enemies, Hazard, Other}

export(IDS) var Id : int = 0
export(NodePath) var Character : NodePath
export(int) var hit_effect_dist : int = 0

onready var Char_Node : Node2D = get_node(Character)

func _on_Hitbox_entered(area):
	if self.Id != area.Id:
		if not Char_Node.invencible:

			var hit_dir = (area.global_position - self.global_position).normalized()
			var direction = area.Direction

			if area.Damage > 0:
				$OnHitEffect.position = hit_dir*(self.get_child(1).shape.radius+hit_effect_dist)
				$OnHitEffect.frame = 0
				$OnHitEffect.play()

			if area.Knockback_Type == 1: direction = -hit_dir

			Char_Node._hit(area.Damage, area.Force, direction)
